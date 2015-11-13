# rails g mailer UserMailer account_activation password_reset lock_reset etc

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'mailer'
end
