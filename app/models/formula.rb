class Formula < ActiveRecord::Base
  after_initialize :set_defaults

  has_many :formulas_progress_steps
  has_many :progress_steps, -> { order(position: :asc) }, through: :formulas_progress_steps
  has_many :formulas_assets

  accepts_nested_attributes_for :formulas_progress_steps, reject_if: :reject_formula_progress_step #, allow_destroy: true
  accepts_nested_attributes_for :formulas_assets, reject_if: :reject_formula_asset #, allow_destroy: true

  validates :code, presence: true, uniqueness: true
  validates :priority, inclusion: { in: (1..3) }
  validate :comments_check_character_encoding

  scope :state, -> (state) { where state: state }
  scope :non_ascii_comments, -> { where("comments <> CONVERT(comments USING ASCII)") }

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
        (`Product Code`, `Product Name`, `Priority`, `Status`, `Sr_Mgmt_Rev_BY`, `Start Date`, `Requested By`, `Customer`)
      VALUES
        (NEW.code, NEW.name, NEW.priority, NEW.state, NEW.reviewed_by, NEW.start_date, NEW.requested_by, NEW.customer);

      INSERT INTO #{destination_db}.new_product_progress_data_comments
        (`Product Code`, `Comments`)
      VALUES
        (NEW.code, NEW.comments);
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
            `Sr_Mgmt_Rev_BY` = NEW.reviewed_by,
            `Start Date` = NEW.start_date,
            `Requested By` = NEW.requested_by,
            `Customer` = NEW.customer
      WHERE `Product Code` = OLD.code;

      UPDATE #{destination_db}.new_product_progress_data_comments
        SET `Comments` = NEW.comments
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
      DELETE FROM #{destination_db}.new_product_progress_data_comments
      WHERE `Product Code` = OLD.code;

      DELETE FROM #{destination_db}.new_product_progress_data
      WHERE `Product Code` = OLD.code;
    END thisTrigger
    SQL
  end

  private

  def comments_check_character_encoding
    # NOTE: this is required to support MySql ODBC 3.51 for MEMO field
    comments.try(:encode!, 'us-ascii')
  rescue Encoding::UndefinedConversionError => e
    errors.add(:comments, "has invalid character encoding: #{e.message}")
  end

  def set_defaults
    self.priority ||= 3
  end
end
