# app/controllers/base_controller.rb
class BaseController < ActionController::Base
  include ActionController::ImplicitRender
  respond_to :json

  before_filter :authenticate_user_from_token!
  before_filter :block_unauthenticated_user!

  # Return the standard error as json
  rescue_from StandardError do |exception|
    render custom_err({general: [exception.to_s]})
  end

  protected
    # @params {Hash} errors key value errors
    # @returns Json Object with Errors and Status.
    def custom_err(errors)
      return :json => {
        errors: errors,
        status: 422,
      },
      status: :unprocessable_entity

    end

    # Returns The currently logged in user
    #
    # @returns {ActiveRecord} User instance
    def current_user
      if jwt_token_from_request.blank?
        nil
      else
        authenticate_user_from_token!
      end
    end
    alias_method :devise_current_user, :current_user

    # Whether or not the user is logged in.
    #
    # @returns boolean
    def user_signed_in?
      !current_user.nil?
    end
    alias_method :devise_user_signed_in?, :user_signed_in?

    # Authenticate a user from their token
    #
    # @returns {ActiveRecord} User instance
    def authenticate_user_from_token!
      decoded = claims
      
      # XSRF Check before authenticating
      xsrf_token = BCrypt::Password.new(decoded[0]['xsrf_token'])
      unless(xsrf_token == xsrf_token_from_request)
        return nil
      end

      #Attempt to authenticate after the XSRF Check
      if decoded and user = User.find_by(email: decoded[0]['email'], id: decoded[0]['id'])
        @current_user = user
      else
        @current_user = nil
      end
    end

    # If a user is not logged in, return an unauthorized response
    def block_unauthenticated_user!
      unless current_user
        return render_unauthorized
      end
    end

    # Decodes your data from the token
    def claims
      JWT.decode(jwt_token_from_request, Rails.application.secrets.secret_key_base, true)
    rescue
      nil
    end

    # Endcodes your User and Password into a token that last 2 weeks.
    #
    # @params {string} user hash
    # @params {string} xsrf_token The token for protecting from xsrf requests
    # @returns {string} - The encoded token
    def jwt_token user, xsrf_token
      # 2 Weeks
      expires = Time.now.to_i + (3600 * 24 * 14)
      token = JWT.encode(
        {
          :email => user.email,
          :id => user.id,
          :exp => expires,
          # Hash the xsrf token so that it can't be read from the jwt
          :xsrf_token => BCrypt::Password.create(xsrf_token),
        },
        Rails.application.secrets.secret_key_base, 'HS256',
      )

      # Set a cookie on the client for the jwt token.
      # We will let the client remove the token when invalidated
      cookies["jwt_token"] = { :value => token, :httponly => true, :expires => 1.years.from_now }

      return token
    end
    
    # Generate an XSRF Token
    def xsrf_token
      SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64 + SecureRandom.urlsafe_base64
    end

    # Renders an error response if unauthorized
    def render_unauthorized(payload = { errors: { unauthorized: ["You are not authorized perform this action."] } })
      render json: payload, status: 401
    end

    # Renders an error response if not found
    def render_not_found(type, id, option='id')
      payload = { errors: { general: ["Could not find #{type} with '#{option}'=#{id}"] } }
      render json: payload, status: 404
    end    

    # Returns a jwt token for the logged in user
    #
    # @returns {string}
    def jwt_token_from_request
      # Accepts the token either from the header, a query var or a cookie
      # Header authorization must be in the following format
      # Authorization: Bearer {yourtokenhere}

      # Check if the JWT was sent via a header
      auth_header = request.headers['Authorization'] and token = auth_header.split(' ').last

      #Check if the JWT was sent via a query var
      if(token.to_s.empty?)
        token = request.parameters["token"]
      end
      
      # Check if the JWT was sent via a cookie
      if(token.to_s.empty?)
        token = cookies['jwt_token']
      end

      return token
    end

    # Returns an xsrf_token for the logged in user
    #
    # @returns {string}
    def xsrf_token_from_request
      # Accepts the token either from the header or a query var
      # Header authorization must be in the following format
      token = request.headers['X-XSRF-TOKEN']
      
      if(token.to_s.empty?)
        token = request.parameters["xsrf_token"]
      end

      return token
    end
    
    # #
    # # Permission functions
    # #

    # Makes sure the current user has edit access to the user requested
    #
    # @params {integer} id The manufacturer ID
    def block_if_not_current_user(id)

      render_unauthorized errors: {
        permissions: ["You do not have permission to view / edit"]
      } unless current_user.id == id

    end

    # # Makes sure the current user has edit access to the editorship
    # #
    # # @params {integer} id The editorship ID
    # def block_editorship_non_editors(id)
    #   manufacturer_id = Editorship.find(id).manufacturer.id
    #   block_manufacturer_non_editors(manufacturer_id)

    # end

    # Sets the User as the Current User
    def set_user
      @user = current_user
    end
end
