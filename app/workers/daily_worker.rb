class DailyWorker
  include Sidekiq::Worker

  DAILY = 1

  def perform action
    case action
    when DAILY
      send_mail_daily
    end
  end

  private
  def send_mail_daily
    UserMailer.mail_daily.deliver
  end
end
