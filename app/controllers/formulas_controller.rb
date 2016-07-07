class FormulasController < ApplicationController
  before_action :set_formula, only: [:show, :edit, :update, :destroy]

  # GET /formulas
  def index
    @formulas = Formula.all
  end

  # GET /formulas/1
  def show
  end

  # GET /formulas/new
  def new
    @formula = Formula.new
  end

  # GET /formulas/1/edit
  def edit
  end

  # POST /formulas
  def create
    @formula = Formula.new(formula_params)

    if @formula.save
      redirect_to @formula, notice: 'Formula was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /formulas/1
  def update
    if @formula.update(formula_params)
      redirect_to @formula, notice: 'Formula was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /formulas/1
  def destroy
    @formula.destroy
    redirect_to formulas_url, notice: 'Formula was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formula
      @formula = Formula.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def formula_params
      params.require(:formula).permit(:code, :name, :state, :comments, :sales_to_date, :reviewed_by)
    end
end
