class SupervisorWorker
  include Sidekiq::Worker

  FINISH = 1

  def perform action, course_id
    case action
    when FINISH
      send_email_notify_course_finish course_id
    end
  end

  private
  def send_email_notify_course_finish course_id
    @course = Course.find_by id: course_id
    UserMailer.finish_course_after_two_days(@course).deliver
  end
end
