class ProgressStep < ActiveRecord::Base
  has_many :formulas_progress_steps
  has_many :formulas, through: :formulas_progress_steps

  acts_as_list

  default_scope -> { order(position: :asc) }

  scope :active, -> do
    sql = <<-SQL
      :current_time BETWEEN `progress_steps`.`effective_on`
        AND IFNULL(`progress_steps`.`effective_until`, :current_time)
    SQL
    where(sql, current_time: Time.now)
  end
end
