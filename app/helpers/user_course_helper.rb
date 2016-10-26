module UserCourseHelper

  def get_course_status object
    object.course
  end

  def show_status_course course
    case
    when course.pending?
      t "course.success"
    when course.started?
      t "course.primary"
    else
      t "course.info"
    end
  end

  def show_status_subject course_subject
    case
    when course_subject.pending?
      t "course.success"
    when course_subject.started?
      t "course.primary"
    else
      t "course.info"
    end
  end

  def type_status status
    case status
    when t("subject.pending")
      t "course.success"
    when t("subject.started")
      t "course.primary"
    else
      t "course.info"
    end
  end

  def name_subject status
    case status
    when t("subject.pending")
      t "subject.text_new"
    when t("subject.started")
      t "subject.text_started"
    else
      t "subject.text_finished"
    end
  end

  def count_status_subject object, status
    object.count_status(status)
  end
end
