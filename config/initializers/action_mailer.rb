# Yes, send e-mail. Raise email delivery errors.
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true


if Rails.env.development?
  # User Letter Opener in Development
  ActionMailer::Base.delivery_method = :letter_opener
else
  # Use SMTP in other environments
  ActionMailer::Base.delivery_method = :smtp
end


ActionMailer::Base.smtp_settings = {
  port: ENV.fetch("MAILGUN_SMTP_PORT"),
  address: ENV.fetch("MAILGUN_SMTP_SERVER"),
  user_name: ENV.fetch("MAILGUN_SMTP_LOGIN"),
  password: ENV.fetch("MAILGUN_SMTP_PASSWORD"),
  authentication: :login,
  enable_starttls_auto: true,
}

# Infer the current domain name from EXPECTED_HOSTNAME and PORT
ActionMailer::Base.default_url_options[:host] = ENV.fetch("EXPECTED_HOSTNAME").split("://").last
ActionMailer::Base.default_url_options[:host] << ":#{ENV.fetch("PORT")}" if Rails.env.development?
