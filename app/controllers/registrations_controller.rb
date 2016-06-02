# app/controllers/api/registrations_controller.rb
class RegistrationsController < BaseController
  skip_before_filter :authenticate_user_from_token!, :only => [:create, :send_password_reset_instructions, :reset_password]
  skip_before_filter :block_unauthenticated_user!, :only => [:create, :send_password_reset_instructions, :reset_password]
  before_action only: [:update] do
    block_if_not_current_user(params[:id].to_i)
  end

  def create

    @user = User.new(user_params)

    if(@user.save)
      @auth_token = jwt_token(@user, user_params['password'])
      @data = @user.as_json
      @data['token'] = @auth_token

    # Successful JSON in /views/registrations
    else
      respond_with @user do 
        'registrations/error'
      end
    end

  end

  def show
    @user = User.find(params[:id])   
    @auth_token = token_from_request
    render 'registrations/public'
  end

  def update
    @user = User.find(params[:id])

    updates = user_params.as_json
  
    if @user.update(updates)
      # We need to update the token since it depends on user data
      if(user_params.has_key?('password'))
        @auth_token = jwt_token(@user, user_params[:password])
      else
        @auth_token = jwt_token(@user, claims[0]['password'])
      end
      
      render 'registrations/show'
      
    else
      render json: @user.errors
    end
  end

  def destroy 
    @user = User.find(params[:id])
    if @user.destroy
      render json: { deleted_id: params[:id].to_i }
    else 
      render json: @user.errors
    end 
  end  

  def send_password_reset_instructions
    user = User.find_by(email: params[:user][:email])
    if(user)
      token = SecureRandom.urlsafe_base64(64)
      user.reset_password_token = token
      user.reset_password_sent_at = Time.now.utc
      user.save(validate: false)
      
      PasswordResetMailer.password_reset_instructions_email(user, token).deliver
      return render text: 'Success', status: 200 
    else
      render text: 'Not Found', status: 404
    end
  end

  # Resets the password when given a user's email and reset password token
  def reset_password
    # Make sure there is an email with the user and reset token
    user = User.find_by({
      email: params[:user][:email],
      reset_password_token: params[:user][:reset_password_token],
    })
   
    if user
      # Make sure the password reset token is only good for 10 minutes
      if (Time.now > user.reset_password_sent_at + 10.minutes)
        # Invalidate the password reset data
        user.reset_password_token = nil
        user.reset_password_sent_at = nil
        user.save
        return render json: {errors: {general: ['Your password reset token has expired']}}, status: 400
      else
        # If the password confirmation matches the password
        if(params[:user][:password] === params[:user][:password_confirmation])
          user.password = params[:user][:password]
          # Invalidate the password reset data
          user.reset_password_token = nil
          user.reset_password_sent_at = nil
          user.save
          return render text: 'Success', status: 200 
        else
          # if the password confirmation was incorrect
          return render json: {
            errors: {
              fields: {
                password_confirmation: ['Your passwords did not match']
              }
            }
          }
        end

      end
    else
      return render text: 'Not found', status: 404 
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

end
