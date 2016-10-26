User.create! name:  "Trainee", email: "trainee@gmail.com", password: "123456",
  password_confirmation: "123456", role: 0
User.create! name: "Supervisor", email: "supervisor@gmail.com",
  password: "123456", password_confirmation: "123456", role: 1
User.create! name: "Admin", email: "admin@gmail.com", password: "123456",
  password_confirmation: "123456", role: 2

15.times do
  params = {
    subject: {
      name: Faker::Name.name,
      description: Faker::Hacker.say_something_smart,
      tasks_attributes: [
        {
          name: Faker::Name.name,
          description: Faker::Hacker.say_something_smart,
          _destroy: false
        }
      ]
    }
  }
  Subject.create! params[:subject]
end

10.times do
  subject = Subject.offset(rand(Subject.count)).first
  params = {
    course: {
      name: Faker::Name.name,
      description: Faker::Hacker.say_something_smart,
      start_date: "2016-10-05",
      end_date: "2017-01-05",
      user_id: 3,
      course_subjects_attributes: [
        {
          subject_id: subject.id,
          _destroy: false
        }
      ]
    }
  }
  Course.create! params[:course]
end

14.times do |n|
  name  = Faker::Name.name
  email = "trainee#{n+1}@trainee.com"
  password = "123456"
  User.create!(name:  name, email: email, password: password,
    password_confirmation: password, role: 0)
end

4.times do |n|
  name  = "supervisor#{n+1}"
  email = "supervisor#{n+1}@super.com"
  password = "123456"
  User.create!(name:  name, email: email, password: password,
    password_confirmation: password, role: 1)
end

2.times do |n|
  name  = "admin#{n+1}"
  email = "admin#{n+1}@admin.com"
  password = "123456"
  User.create!(name:  name, email: email, password: password,
    password_confirmation: password, role: 2)
end
