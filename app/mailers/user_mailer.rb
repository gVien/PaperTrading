class UserMailer < ApplicationMailer

  # sends activation email
  def account_activation(user)
    @user = user  # instance variable so the mailer view can have access
    mail to: user.email, subject: "Activate your PaperTrading account"  # sending the email to this user
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
