class UserPolicy < ApplicationPolicy

  def permitted_attributes
    # if user.admin? || user.owner_of?(post)
    if user.has_role? :super_user
      [
        :code, :name, :priority, :state, :comments, :reviewed_by,
        formulas_assets_attributes: [:id, :asset],
        formulas_progress_steps_attributes: [:id, :progress_step_id, :completed, :completed_on, :comments]
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
