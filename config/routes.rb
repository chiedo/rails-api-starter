Rails.application.routes.draw do

  # By using the format false option, we restrict the api to only serving json
  # It is commen to namespace /api, however we did not to simplify over the many stacks.
  scope :format => false, :defaults => { format: :json} do

    # Example routes
    match 'public', :to => 'examples#example_public', via: :get
    match 'private', :to => 'examples#example_private', via: :get
    
    #
    # (User routes)
    #
    match 'users/', :to => 'registrations#create', via: :post
    match 'users/:id/', :to => 'registrations#update', via: :put
    match 'users/:id/', :to => 'registrations#destroy', via: :delete
    match 'users/send-password-reset-email', :to => 'registrations#send_password_reset_instructions', via: :post
    match 'users/reset-password', :to => 'registrations#reset_password', via: :post

    # Authentication routes
    post 'sign-in', to: 'sessions#create'
    post 'sign-out', to: 'sessions#destroy'
  end
end
