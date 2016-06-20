# User Object From Controller
object false

node(:user) {
  partial('registrations/user-base', :object => @user)
}

node(:token) { @jwt_token}
node(:xsrf_token) { @xsrf_token }
