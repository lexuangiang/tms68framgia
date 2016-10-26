class Admin::UserCoursesController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin
  before_action :load_course, only: [:show, :update]
  load_and_authorize_resource

  def show
    @course.build_user_courses @course.users
  end

  def update
    @course.update_attributes course_params
    if @course.save
      flash[:success] = t "admin.user_courses.action_success"
      redirect_to admin_course_path @course
    else
      render :edit
    end
  end

  private
  def load_course
    @course = Course.find_by id: params[:course_id]
    unless @course
      flash[:danger] = t "admin.user_courses.course_not_found"
      redirect_to admin_courses_path
    end
  end

  def course_params
    params.require(:course)
      .permit user_courses_attributes: [:id, :user_id, :is_active, :_destroy]
  end
end
