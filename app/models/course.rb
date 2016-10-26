class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_subjects
  has_many :subjects, through: :course_subjects
  belongs_to :user
  accepts_nested_attributes_for :course_subjects, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:subject_id].blank? ||
      attributes[:subject_id] == 0}
  accepts_nested_attributes_for :user_courses, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:user_id].blank? ||
      attributes[:user_id] == 0}

  enum status: {pending: 0, started: 1, finished: 2}

  acts_as_paranoid

  validates :name, presence: true
  validates :description, presence: true, length: {minimum: 10}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :validate_subjects

  after_update :update_active, :update_status_subject, :create_user_subjects
  after_create :send_mail_finish_after_two_days

  scope :user_subjects_data, -> do
    UserCourse.joins "INNER JOIN course_subjects ON user_courses.course_id = course_subjects.course_id"
  end

  def update_active
    UserCourse.where("user_courses.course_id = ?", id).update_all is_active: started?
  end

  def update_status_subject
    if Course.statuses[self.status] == 2
      CourseSubject.where("course_subjects.course_id = ?", id)
        .update_all status: Course.statuses[self.status]
    end
  end

  def create_user_subjects
    if self.started?
      user_courses = self.user_courses
      course_subjects = self.course_subjects
      user_courses.each do |user_course|
        status = 0
        course_subjects.each do |course_subject|
          user_subject = UserSubject.find_by user_course_id: user_course.id,
            user_id: user_course.user_id, subject_id: course_subject.subject_id
          unless user_subject
            UserSubject.create user_course_id: user_course.id, status: status,
            user_id: user_course.user_id, subject_id: course_subject.subject_id
          end
        end
      end
    end
  end

  def in_active_course
    user_ids = "SELECT user_id FROM user_courses WHERE course_id = :course_id"
    UserCourse.joins("INNER JOIN users ON user_courses.user_id = users.id
      INNER JOIN courses ON user_courses.course_id = courses.id").
      where "user_courses.is_active = :user_course_status AND
      user_courses.user_id IN (#{user_ids}) AND user_courses.course_id != :course_id
      AND users.role = :trainee AND courses.status = :course_status",
      user_course_status: Settings.is_active_true, course_id: id, trainee: 0, course_status: 1
  end

  def is_deactive_course
    user_ids = "SELECT user_id FROM user_courses WHERE is_active = true"
    User.where "users.id NOT IN (#{user_ids})"
  end

  def build_course_subjects add_subjects = {}
    Subject.all.each do |subject|
      unless add_subjects.include? subject
        self.course_subjects.build subject_id: subject.id
      end
    end
  end

  def build_user_courses add_users = Array.new
    if self.started?
      @users = self.is_deactive_course
    else
      @users = User.all
    end
    @users.each do |user|
      unless add_users.include? user
        self.user_courses.build user_id: user.id
      end
    end
  end

  private
  def validate_subjects
    count = course_subjects.select{|course_subject| !course_subject._destroy}.count
    if count < Settings.course_subject_quanlity
      errors.add :subjects, I18n.t("admin.courses.subject_quanlity_error")
    end
  end

  def send_mail_finish_after_two_days
    SupervisorWorker.perform_at (end_date - 2.days).to_s,
      SupervisorWorker::FINISH, self.id
  end
end
