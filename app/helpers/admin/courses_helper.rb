module Admin::CoursesHelper

  def show_status course
    case
    when course.pending?
      t "admin.courses.course_pending"
    when course.started?
      t "admin.courses.course_started"
    else
      t "admin.courses.course_finished"
    end
  end
end
