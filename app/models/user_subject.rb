class UserSubject < ApplicationRecord
  include ActivityLog
  belongs_to :user
  belongs_to :user_course
  belongs_to :subject
  has_many :user_tasks, dependent: :destroy
  has_many :tasks, through: :subject

  enum status: {pending: 0, started: 1, finished: 2}

  tracked only: :update, owner: Proc.new{|controller| controller.current_user}

  accepts_nested_attributes_for :user_tasks, allow_destroy: true,
    reject_if: proc{|attribute| attribute[:task_id].nil?}

  scope :find_by_subject,->user_id, subject_id, user_course_id do
    find_by(user_id: user_id, subject_id: subject_id, user_course_id: user_course_id)
  end

  scope :count_status,->status do
    where(status: status).count(:status)
  end

  scope :count_subject,->user_id do
    where(user_id: user_id).count(:subject_id)
  end

  def all_activities
    PublicActivity::Activity.where(trackable_id: user_tasks.ids,
      trackable_type: UserTask.name).order("created_at desc")
  end

  def update_status
    task_count = tasks.count
    user_task_count = user_tasks.count
    if task_count == 0 || user_task_count <= 0
      pending!
    else
      if user_task_count < task_count
        started!
      elsif user_task_count >= task_count
        finished!
      end
    end
  end
end
