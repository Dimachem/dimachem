class Formula < ActiveRecord::Base
  has_many :formulas_progress_steps
  has_many :progress_steps, -> { order(position: :asc) }, through: :formulas_progress_steps
  has_many :formulas_assets

  accepts_nested_attributes_for :formulas_progress_steps, reject_if: :reject_formula_progress_step #, allow_destroy: true
  accepts_nested_attributes_for :formulas_assets, reject_if: :reject_formula_asset #, allow_destroy: true

  validates :code, presence: true

  scope :state, -> (state) { where state: state }

  state_machine :state, :initial => :open do

    event :complete do
      transition :open => :completed
    end

    event :archive do
      transition :open => :archived
    end

  end

  def self.state_options(with_all=false)
    state_machine.states.map{|s| [s.name, s.name] }
  end

  def reject_formula_progress_step(attributes)
    attributes[:completed] == 'false' &&
    attributes[:completed_on].blank? &&
    attributes[:comments].blank?
  end

  def reject_formula_asset(attributes)
    attributes[:asset].blank?
  end

  trigger.after(:insert) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      INSERT INTO #{destination_db}.new_product_progress_data
        (`Product Code`, `Product Name`, `Priority`, `Status`, `Comments`, `Sr_Mgmt_Rev_BY`)
      VALUES
        (NEW.code, NEW.name, NEW.priority, NEW.state, NEW.comments, NEW.reviewed_by);
    END thisTrigger
    SQL
  end

  trigger.after(:update) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      UPDATE #{destination_db}.new_product_progress_data
        SET `Product Name` = NEW.name,
            `Priority` = NEW.priority,
            `Status` = NEW.state,
            `Comments` = NEW.comments,
            `Sr_Mgmt_Rev_BY` = NEW.reviewed_by
      WHERE `Product Code` = OLD.code;
    END thisTrigger
    SQL
  end

  trigger.after(:delete) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      DELETE FROM #{destination_db}.new_product_progress_data
      WHERE `Product Code` = OLD.code;
    END thisTrigger
    SQL
  end

end
