require 'test_helper'

class FormulasControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @formula = formulas(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formulas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formula" do
    assert_difference('Formula.count') do
      post :create, formula: {
        code: SecureRandom.uuid,
        comments: @formula.comments,
        name: @formula.name,
        reviewed_by: @formula.reviewed_by,
        sales_to_date: @formula.sales_to_date,
        state: @formula.state
      }
    end

    assert_redirected_to formula_path(assigns(:formula))
  end

  test "should show formula" do
    get :show, id: @formula
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @formula
    assert_response :success
  end

  test "should update formula" do
    patch :update, id: @formula, formula: {
      code: @formula.code,
      comments: @formula.comments,
      name: @formula.name,
      reviewed_by: @formula.reviewed_by,
      sales_to_date: @formula.sales_to_date,
      state: @formula.state
    }

    assert_redirected_to formula_path(assigns(:formula))
  end

  # test "should destroy formula" do
  #   assert_difference('Formula.count', -1) do
  #     delete :destroy, id: @formula
  #   end
  #
  #   assert_redirected_to formulas_path
  # end
end
