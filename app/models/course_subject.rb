class CourseSubject < ApplicationRecord
  belongs_to :course
  belongs_to :subject

  enum status: {pending: 0, started: 1, finished: 2}

  after_update :update_status

  scope :of_course_and_subject,->course_id, subject_id do
    find_by course_id: course_id, subject_id: subject_id
  end

  scope :count_status,->status do
    where(status: status).count(:status)
  end

  def update_status
    if CourseSubject.statuses[self.status] != 0
      UserSubject.where("user_subjects.subject_id = ?", self.subject_id)
        .update_all status: CourseSubject.statuses[self.status]
    end
  end
end
