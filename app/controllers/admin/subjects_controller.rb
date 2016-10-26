class Admin::SubjectsController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin_only
  load_and_authorize_resource

  def index
  end

  def show
    @tasks = @subject.tasks
  end

  def new
    @subject = Subject.new
    @task = @subject.tasks.build
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "admin.subjects.create_success"
      redirect_to admin_subject_path @subject
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "admin.subjects.update_success"
      redirect_to admin_subject_path @subject
    else
      render :edit
    end
  end

  def destroy
    if @subject.is_inprogess?
      flash[:danger] = t ".cannot_delete"
    else
      if @subject.destroy
        flash[:success] = t ".delete_success"
      else
        flash[:danger] = t ".delete_fail"
      end
    end
    redirect_to admin_subjects_path
  end

  private
  def subject_params
    params.require(:subject).permit :name, :description, :image_url,
      tasks_attributes: [:id, :name, :description, :_destroy]
  end
end
