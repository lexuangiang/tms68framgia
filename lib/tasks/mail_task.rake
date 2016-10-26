namespace :mail_task do
  desc "TODO"
  task mail_month: :environment do
    MonthlyWorker.perform_async MonthlyWorker::MONTHLY
  end

  desc "TODO"
  task mail_daily: :environment do
    DailyWorker.perform_async DailyWorker::DAILY
  end

  desc "TODO"
  task mail_finish: :environment do
    SupervisorWorker.perform_async SupervisorWorker::FINISH, Course.last.id
  end

end
