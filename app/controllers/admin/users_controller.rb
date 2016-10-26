class Admin::UsersController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin
  load_and_authorize_resource

  def index
    @users = User.trainee if current_user.supervisor?
  end

  def show
    @user_courses = UserCourse.inprogress_by_user(@user)
    @course_finish = UserCourse.by_user_finish(@user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".create_success"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update_success"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :role
  end
end
