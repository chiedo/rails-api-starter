class SessionsController < BaseController
  skip_before_filter :authenticate_user_from_token!, :only => 'create'
  skip_before_filter :block_unauthenticated_user!, :only => 'create'
  before_filter :ensure_params_exist, :only => 'create'

  # @description POST /sign-in
  # @param {string} id - User's id. Implicit Paramater. Is required.  
  # @param {string} Authorization - Authentication token. Format is'Bearer: tokenvalue' and is required.
  #      
  # @returns JSON Object of User 
  def create
    @user = User.find_for_database_authentication(email: user_params[:email])
    return invalid_login_attempt unless @user
    return invalid_login_attempt unless @user.valid_password?(user_params[:password])
    
    # Create the tokens
    @xsrf_token = xsrf_token()
    @jwt_token = jwt_token(@user, @xsrf_token)
  end

  def destroy
    cookies.delete :jwt_token

    return render json: {:success => true}
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

    # Calls renders render_unauthorized with passed in error. 
    # Checks if email or password are blank   
    def ensure_params_exist
      if user_params[:email].blank? || user_params[:password].blank?
        return render_unauthorized errors: { unauthenticated: ["Incomplete credentials"] }
      end
    end

    # Calls renders render_unauthorized with passed in error. 
    def invalid_login_attempt
      render_unauthorized errors: { unauthenticated: ["Invalid credentials"] }
    end
end
