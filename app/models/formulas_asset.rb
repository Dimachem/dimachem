class FormulasAsset < ActiveRecord::Base
  has_attached_file :asset,
    url: "/uploads/:rails_env/:class/:attachment/:id_partition/:style/:filename",
    path: ":rails_root/public/uploads/:rails_env/:class/:attachment/:id_partition/:style/:filename",
    preserve_files: true

  belongs_to :formula

  validates_attachment :asset,
    presence: true,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "application/msword"] }

    # trigger.after(:insert) do
    #   destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']
    #
    #   <<-SQL
    #   thisTrigger: BEGIN
    #     IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
    #       LEAVE thisTrigger;
    #     END IF;
    #
    #     SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
    #     SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;
    #
    #     UPDATE #{destination_db}.new_product_progress_data
    #     SET `FileName` = NEW.asset_file_name,
    #         `ContentType` = NEW.asset_content_type,
    #         `FileSize` = NEW.asset_file_size
    #     WHERE `Product Code` = @PRODUCT_CODE;
    #   END thisTrigger
    #   SQL
    # end
    #
    # trigger.after(:update) do
    #   destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']
    #
    #   <<-SQL
    #   thisTrigger: BEGIN
    #     IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
    #       LEAVE thisTrigger;
    #     END IF;
    #
    #     SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
    #     SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;
    #
    #     UPDATE #{destination_db}.new_product_progress_data
    #     SET `FileName` = NEW.asset_file_name,
    #         `ContentType` = NEW.asset_content_type,
    #         `FileSize` = NEW.asset_file_size
    #     WHERE `Product Code` = @PRODUCT_CODE;
    #   END thisTrigger
    #   SQL
    # end
    #
    # trigger.after(:delete) do
    #   destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']
    #
    #   <<-SQL
    #   thisTrigger: BEGIN
    #     IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
    #       LEAVE thisTrigger;
    #     END IF;
    #
    #     SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
    #     SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;
    #
    #     UPDATE #{destination_db}.new_product_progress_data
    #     SET `FileName` = NULL,
    #         `ContentType` = NULL,
    #         `FileSize` = NULL
    #     WHERE `Product Code` = @PRODUCT_CODE;
    #   END thisTrigger
    #   SQL
    # end

end
