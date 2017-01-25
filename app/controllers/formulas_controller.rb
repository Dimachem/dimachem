class FormulasController < ApplicationController
  before_action :set_formula, only: [:show, :edit, :update, :destroy]

  before_action only: [:index] do
    skip_policy_scope
    get_query('query_formulas')
  end

  # GET /formulas
  def index
    @search = Formula.ransack(@query)
    @search.build_sort({name: 'priority', dir: 'asc'}) if @search.sorts.blank?
    @search.state_eq = 'open' unless params_has_state_condition?

    @formulas = @search.result
  end

  # GET /formulas/1
  def show
    authorize @formula
    # build_progress_steps(@formula)
  end

  # GET /formulas/new
  def new
    authorize Formula
    @state_select_options = Formula.state_options
    @details_title = 'New Formula'
    @default_collapse_state = 'in'
    @formula = Formula.new
    @formula.formulas_assets.build
    build_progress_steps(@formula)
  end

  # GET /formulas/1/edit
  def edit
    authorize @formula
    @state_select_options = Formula.state_options
    @details_title = @formula.name
    @formula.formulas_assets.build
    build_progress_steps(@formula)
  end

  # POST /formulas
  def create
    @formula = Formula.new(formula_params)
    authorize @formula
    build_multiple_assets

    if @formula.save
      redirect_to @formula, notice: 'Formula was successfully created.'
    else
      @state_select_options = Formula.state_options
      build_progress_steps(@formula)
      render :new
    end
  end

  # PATCH/PUT /formulas/1
  def update
    authorize @formula
    build_multiple_assets

    if @formula.update(formula_params)
      redirect_to @formula, notice: 'Formula was successfully updated.'
    else
      @state_select_options = Formula.state_options
      build_progress_steps(@formula)
      render :edit
    end
  end

  # # DELETE /formulas/1
  # def destroy
  #   @formula.destroy
  #   redirect_to formulas_url, notice: 'Formula was successfully destroyed.'
  # end

  private

  def build_multiple_assets
    base = @formula.formulas_assets.count
    assets = params[:formula].delete(:assets) || []

    assets.each_with_index do |asset, index|
      added_asset = {(base + index).to_s => {"asset" => asset}}
      params[:formula][:formulas_assets_attributes] ||= {}
      params[:formula][:formulas_assets_attributes].merge!(added_asset)
    end
  end

  def build_progress_steps(formula)
    build_steps = policy_scope(ProgressStep.active) -
      policy_scope(formula.progress_steps)
    build_steps.each do |progress_step|
      formula.formulas_progress_steps.build(progress_step: progress_step)
    end
  end

  def params_has_state_condition?
    return false unless params[:q].try(:[], :c).present?
    params[:q][:c].values.any? do |c|
      # any condition attributes include state?
      c[:a].values.any? {|a| a.values.include? 'state'} # &&
      # c[:v].values.any? {|v| v.values.include? 'all'}
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_formula
    @formula = Formula.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def formula_params
    params.require(:formula).permit(policy(Formula).permitted_attributes)
  end
end
