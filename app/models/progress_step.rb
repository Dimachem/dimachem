class ProgressStep < ActiveRecord::Base
  has_many :formulas_progress_steps
  has_many :formulas, through: :formulas_progress_steps

  acts_as_list scope: :formulas

  default_scope -> { order(position: :asc) }
end
