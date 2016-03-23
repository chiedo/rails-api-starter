Rails.application.routes.draw do

  # By using the format false option, we restrict the api to only serving json
  # It is commen to namespace /api, however we did not to simplify over the many stacks.
  scope :format => false, :defaults => { format: :json} do
    
    #
    # Devise routes (User routes)
    #
    devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
    match 'users/:id/', :to => 'registrations#update', via: :put
    match 'users/:id/', :to => 'registrations#destroy', via: :delete
    devise_scope :user do
      post 'sign-in', to: 'sessions#create'
    end  
  end
end
