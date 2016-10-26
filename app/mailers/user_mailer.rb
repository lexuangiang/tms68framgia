class UserMailer < ApplicationMailer
  default from: Settings.mail_from

  def asign_to_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: t("mail.asign_to_course",
      name: @course.name)
  end

  def reject_from_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: t("mail.reject_from_course",
      name: @course.name)
  end

  def finish_course_after_two_days course
    @course = course
    @user = @course.user
    mail to: @user.email, subject: t("mail.before_course_finish",
      name: @course.name)
  end

  def mail_month
    Course.all.each do |course|
      @supervisor = course.user
      @trainee = course.users
      @course = course
      mail to: @supervisor.email, subject: t("mail.mail_month")
    end
  end

  def mail_daily
    User.supervisor.each do |supervisor|
      @supervisor = supervisor
      @user_tasks = UserTask.all
      mail to: @supervisor.email, subject: t("mail.mail_daily")
    end
  end
end
