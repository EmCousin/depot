class ErrorNotifier < ActionMailer::Base
  default from: "admin@depot.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.occured.subject
  #
  def occured(error)
    @error = error
    mail to: "emmanuel_cousin@hotmail.fr", subject: "Error Incident Notification"
  end
end
