class Admin::StaticPagesController < ApplicationController
  layout "admin_application"
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @courses = Course.all
    @subjects = Subject.all
    @users = User.all
  end
end
