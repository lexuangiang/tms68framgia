class Admin::CourseSubjectsController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin
  load_and_authorize_resource

  def update
    @course_subject.update_attributes course_subject_params
    if @course_subject.save
      flash[:success] = t "admin.user_courses.action_success"
    else
      flash[:success] = t "admin.user_courses.action_success"
    end
      redirect_to admin_course_path @course_subject.course
  end

  def course_subject_params
    params.require(:course_subject).permit :status
  end
end
