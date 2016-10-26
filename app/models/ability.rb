class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.supervisor?
      can :manage, :all
      cannot :manage, Subject
    else
      can [:update, :read], User, id: user.id
      can [:read], Task
      can [:create], UserTask, user_id: user.id
      can [:create, :read], UserSubject, user_id: user.id
      can [:read], UserCourse, user_id: user.id
      can [:update], UserSubject, user_id: user.id
    end
  end
end
