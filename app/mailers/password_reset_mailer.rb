class PasswordResetMailer < ApplicationMailer
  def password_reset_instructions_email(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end

