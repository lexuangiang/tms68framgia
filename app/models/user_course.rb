class UserCourse < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :user_subjects, dependent: :destroy
  has_many :subjects, through: :user_subjects

  after_create :send_mail_asign_course
  before_destroy :send_mail_reject_course

  scope :status_of_course,->status do
    joins(:course).where "courses.status = ?", status
  end

  scope :inprogress_by_user,->user{where user_id: user.id,
    is_active: true}

  scope :by_user_finish, ->user_id do
    UserCourse.joins("INNER JOIN courses ON user_courses.course_id = courses.id").where "courses.status = 2 AND user_courses.user_id = ?", user_id
  end

  private
  def send_mail_asign_course
    UserWorker.perform_async UserWorker::ASSIGN_TO_COURSE,
      self.user_id, self.course_id
  end

  def send_mail_reject_course
    UserWorker.perform_async UserWorker::REJECT_FROM_COURSE,
      self.user_id, self.course_id
  end
end
