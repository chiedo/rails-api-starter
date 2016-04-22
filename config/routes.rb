Rails.application.routes.draw do

  # By using the format false option, we restrict the api to only serving json
  # It is commen to namespace /api, however we did not to simplify over the many stacks.
  scope :format => false, :defaults => { format: :json} do
    
    #
    # Devise routes (User routes)
    #
    match 'users/:id/', :to => 'registrations#update', via: :put
    match 'users/:id/', :to => 'registrations#destroy', via: :delete
    match 'users/send-password-reset-email', :to => 'registrations#send_password_reset_instructions', via: :post
    match 'users/reset-password', :to => 'registrations#reset_password', via: :post
    devise_scope :user do
      post 'sign-in', to: 'sessions#create'
    end  
  end
end
