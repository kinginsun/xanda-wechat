class ApplicationMailer < ActionMailer::Base

  default from: ENV['email_provider_username']
  layout 'mailer'

end
