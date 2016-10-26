env :GEM_PATH, ENV['GEM_PATH']
set :environment, "development"
set :output, "/home/thaodtd/log.log"

every 1.day, at:"10:10 am" do
  rake "mail_task:mail_month"
end

every 1.day, at:"10:10 am" do
  rake "mail_task:mail_daily"
end
