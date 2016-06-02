class ApplicationMailer < ActionMailer::Base
  default from:Rails.application.config.api_from_email
  layout 'mailer'
end
