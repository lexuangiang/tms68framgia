module UsersHelper

  def show_role user
    case
    when user.admin?
      t ".role_admin"
    when user.supervisor?
      t ".role_supervisor"
    else
      t ".role_trainee"
    end
  end
end
