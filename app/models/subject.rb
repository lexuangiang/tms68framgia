class Subject < ApplicationRecord
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :tasks, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  accepts_nested_attributes_for :tasks, allow_destroy: true

  acts_as_paranoid
  mount_uploader :image_url, ImgSubjectUploader

  validates :name, presence: true
  validates :description, presence: true, length: {minimum: 10}
  validate :validate_tasks

  scope :recent, ->{order created_at: :desc}

  def is_inprogess?
    self.courses.each do |course|
      true if course.started?
    end
    false
  end

  private
  def validate_tasks
    if tasks.select{|task| !task._destroy}.count < Settings.task_quanlity
      errors.add :subjects, I18n.t("admin.subjects.task_quanlity_error")
    end
  end
end
