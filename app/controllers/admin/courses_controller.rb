class Admin::CoursesController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin
  load_and_authorize_resource
  before_action :load_subjects, only: [:new, :edit]

  def index
  end

  def show
    @creater = User.find_by id: @course.user_id
    @user_courses = @course.user_courses.includes :user
    @course = Course.includes(course_subjects:[:subject]).find_by id: params[:id]
    @trainees_are_in_active = @course.in_active_course.includes :user
  end

  def new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t "admin.courses.action_success"
      redirect_to admin_courses_path
    else
      @course.build_course_subjects
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "admin.courses.update_success"
      redirect_to admin_course_path @course
    else
      flash[:danger] = t "admin.courses.update_fail"
      render :edit
    end
  end

  def destroy
    if @course.started?
      flash[:danger] = t "admin.courses.cannot_delete"
    else
      if @course.destroy
        flash[:success] = t "admin.courses.delete_success"
      else
        flash[:danger] = t "admin.courses.delete_fail"
      end
    end
    redirect_to admin_course_path @course
  end

  private
  def course_params
    params.require(:course).permit(:name, :description, :start_date, :end_date,
    :status, course_subjects_attributes: [:id, :subject_id, :_destroy])
    .merge user_id: current_user.id
  end

  def load_subjects
    @course.build_course_subjects
  end
end
