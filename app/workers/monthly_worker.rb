class MonthlyWorker
  include Sidekiq::Worker

  MONTHLY = 1

  def perform action
    case action
    when MONTHLY
      send_mail_monthly
    end
  end

  private
  def send_mail_monthly
    UserMailer.mail_month.deliver
  end
end
