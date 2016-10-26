class UserWorker
  include Sidekiq::Worker

  ASSIGN_TO_COURSE = 1
  REJECT_FROM_COURSE = 2

  def perform action, user_id, course_id
    case action
    when ASSIGN_TO_COURSE
      send_email_assigned_to_course user_id, course_id
    when REJECT_FROM_COURSE
      send_email_reject_from_course user_id, course_id
    end
  end

  private
  def send_email_assigned_to_course user_id, course_id
    @user = User.find_by id: user_id
    @course = Course.find_by id: course_id
    UserMailer.asign_to_course(@user, @course).deliver
  end

  def send_email_reject_from_course user_id, course_id
    @user = User.find_by id: user_id
    @course = Course.find_by id: course_id
    UserMailer.reject_from_course(@user, @course).deliver
  end

end
