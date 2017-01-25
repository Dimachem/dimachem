class UserPolicy < ApplicationPolicy

  def permitted_attributes
    # if user.admin? || user.owner_of?(post)
    if user.has_role? :super_user
      [
        users_roles_attributes: [:id, :role_id, :_destroy]
      ]
    else
      []
    end
  end

  def show?
    # user.admin? or not record.published?
    user.has_role? :super_user
  end

  def create?
    user.has_role? :super_user
  end

  def update?
    user.has_role? :super_user
  end

end
