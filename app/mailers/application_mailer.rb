# rails g mailer UserMailer account_activation password_reset lock_reset etc

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@papertrading.com"
  layout 'mailer'
end
