class ProgressStepPolicy < ApplicationPolicy
  def self.black_list_codes
    ['Sr_Mgmt_Rev']
  end

  class Scope < Scope
    def resolve
      if user.has_role?(:super_user) ||
        user.has_role?(:executive_management)
        scope.all
      else
        scope.where("#{scope.table_name}.code NOT IN (?)",
          ProgressStepPolicy.black_list_codes.join('", "'))
      end
    end
  end

  def create?
    user.has_role?(:super_user) ||
    user.has_role?(:administrator)
  end

  def update?
    user.has_role?(:super_user) ||
    user.has_role?(:executive_management) ||
    !self.class.black_list_codes.include?(record.code)
  end
end
