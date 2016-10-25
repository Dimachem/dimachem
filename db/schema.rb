# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160815011715) do

  create_table "formulas", force: :cascade do |t|
    t.string   "code",        limit: 255,   null: false
    t.string   "name",        limit: 255
    t.integer  "priority",    limit: 4
    t.string   "state",       limit: 255
    t.text     "comments",    limit: 65535
    t.string   "reviewed_by", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "formulas", ["code"], name: "index_formulas_on_code", unique: true, using: :btree

  create_table "formulas_assets", force: :cascade do |t|
    t.integer  "formula_id",         limit: 4
    t.string   "asset_file_name",    limit: 255
    t.string   "asset_content_type", limit: 255
    t.integer  "asset_file_size",    limit: 4
    t.datetime "asset_updated_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "formulas_assets", ["formula_id"], name: "index_formulas_assets_on_formula_id", using: :btree

  create_table "formulas_progress_steps", force: :cascade do |t|
    t.integer  "formula_id",       limit: 4
    t.integer  "progress_step_id", limit: 4
    t.boolean  "completed",                    default: false, null: false
    t.datetime "completed_on"
    t.string   "comments",         limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "formulas_progress_steps", ["formula_id", "progress_step_id"], name: "index_formulas_progress_steps_on_formula_id_and_progress_step_id", unique: true, using: :btree
  add_index "formulas_progress_steps", ["formula_id"], name: "index_formulas_progress_steps_on_formula_id", using: :btree
  add_index "formulas_progress_steps", ["progress_step_id"], name: "index_formulas_progress_steps_on_progress_step_id", using: :btree

  create_table "progress_steps", force: :cascade do |t|
    t.string   "code",            limit: 255, null: false
    t.string   "description",     limit: 255, null: false
    t.integer  "position",        limit: 4,   null: false
    t.datetime "effective_on",                null: false
    t.datetime "effective_until"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "progress_steps", ["code"], name: "index_progress_steps_on_code", unique: true, using: :btree
  add_index "progress_steps", ["description"], name: "index_progress_steps_on_description", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",            limit: 255,             null: false
    t.datetime "remember_created_at"
    t.string   "remember_token",      limit: 255
    t.integer  "sign_in_count",       limit: 4,   default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "formulas_assets", "formulas"
  add_foreign_key "formulas_progress_steps", "formulas"
  add_foreign_key "formulas_progress_steps", "progress_steps"
  create_trigger("formulas_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("formulas").
      after(:insert) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      INSERT INTO chemfil1_test.new_product_progress_data
        (`Product Code`, `Product Name`, `Priority`, `Status`, `Comments`, `Sr_Mgmt_Rev_BY`)
      VALUES
        (NEW.code, NEW.name, NEW.priority, NEW.state, NEW.comments, NEW.reviewed_by);
    END thisTrigger;
    SQL_ACTIONS
  end

  create_trigger("formulas_after_update_row_tr", :generated => true, :compatibility => 1).
      on("formulas").
      after(:update) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      UPDATE chemfil1_test.new_product_progress_data
        SET `Product Name` = NEW.name,
            `Priority` = New.priority,
            `Status` = NEW.state,
            `Comments` = NEW.comments,
            `Sr_Mgmt_Rev_BY` = NEW.reviewed_by
      WHERE `Product Code` = OLD.code;
    END thisTrigger;
    SQL_ACTIONS
  end

  create_trigger("formulas_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("formulas").
      after(:delete) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      DELETE FROM chemfil1_test.new_product_progress_data
      WHERE `Product Code` = OLD.code;
    END thisTrigger;
    SQL_ACTIONS
  end

  create_trigger("formulas_progress_steps_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("formulas_progress_steps").
      after(:insert) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = NEW.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Consequences of Failure` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MOC_Com` = NEW.comments,
              `MOC_YN` = NEW.completed,
              `MOC_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger;
    SQL_ACTIONS
  end

  create_trigger("formulas_progress_steps_after_update_row_tr", :generated => true, :compatibility => 1).
      on("formulas_progress_steps").
      after(:update) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Consequences of Failure` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MOC_Com` = NEW.comments,
              `MOC_YN` = NEW.completed,
              `MOC_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger;
    SQL_ACTIONS
  end

  create_trigger("formulas_progress_steps_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("formulas_progress_steps").
      after(:delete) do
    <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Req_Com` = NULL,
              `Cust_Req_YN` = 0,
              `Cust_Req_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Cust_Specs_Com` = NULL,
              `Cust_Specs_YN` = 0,
              `Cust_Specs_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `TDS MSDS Com` = NULL,
              `TDS MSDS YN` = 0,
              `TDS MSDS Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Com` = NULL,
              `Formula YN` = 0,
              `Formula Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NULL,
              `Disc Nature-Duration-Complexity YN` = 0,
              `Disc Nature-Duration-Complexity Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Disc Consequences of Failure` = NULL,
              `Disc Consequences of Failure YN` = 0,
              `Disc Consequences of Failure Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test Proc Rec Com` = NULL,
              `Test Proc Rec YN` = 0,
              `Test Proc Rec Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Spec Com` = NULL,
              `Prod Spec YN` = 0,
              `Prod Spec Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `OK on Raws Com` = NULL,
              `OK on Raws YN` = 0,
              `OK on Raws Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Prod Code Entered Com` = NULL,
              `Prod Code Entered YN` = 0,
              `Prod Code Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MSDS Init Com` = NULL,
              `MSDS Init YN` = 0,
              `MSDS Init Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Lab Batch Com` = NULL,
              `Lab Batch YN` = 0,
              `Lab Batch Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `QC Tests Entered Com` = NULL,
              `QC Tests Entered YN` = 0,
              `QC Tests Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Formula Entered Com` = NULL,
              `Formula Entered YN` = 0,
              `Formula Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `MOC_Com` = NULL,
              `MOC_YN` = 0,
              `MOC_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Env_Aspects_Com` = NULL,
              `Env_Aspects_YN` = 0,
              `Env_Aspects_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NULL,
              `Sr_Mgmt_Rev_YN` = 0,
              `Sr_Mgmt_Rev_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Form to Purch Mang Com` = NULL,
              `Form to Purch Mang YN` = 0,
              `Form to Purch Mang Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE chemfil1_test.new_product_progress_data
          SET `Test proc Forw Com` = NULL,
              `Test proc Forw YN` = 0,
              `Test proc Forw Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger;
    SQL_ACTIONS
  end

end
