# app/controllers/api/registrations_controller.rb
class RegistrationsController < BaseController
  skip_before_filter :authenticate_user_from_token!, :only => [:create, :show]
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

  private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

end
