class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SERVER_EMAIL_ADDRESS")
  layout 'mailer'
end
