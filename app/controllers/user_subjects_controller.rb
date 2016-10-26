class UserSubjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    @user_course = @user_subject.user_course
    @tasks = @user_subject.subject.tasks
    @user_id = @user_subject.user_id
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by task_id: task.id,
        user_id: @user_id
    @count_user_task = @user_subject.user_tasks.count(:task_id)
    @count_task = @user_subject.subject.tasks.count(:subject_id)
    @activities = @user_subject.all_activities.page(params[:page])
    end

  end

  def update
    if @user_subject.update_attributes user_subject_params
       @user_subject.update_status
      flash[:success] = "update success"
    else
      flash[:danger] = "update error"
    end
    redirect_to :back
  end

  private
  def user_subject_params
    params.require(:user_subject).permit :user_id, :subject_id, :user_course_id,
     :status, user_tasks_attributes: [:id, :user_id, :task_id]
  end

end
