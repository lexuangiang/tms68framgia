class UserTask < ApplicationRecord
include ActivityLog
  tracked only: :create, owner: Proc.new{|controller| controller.current_user}

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
end
