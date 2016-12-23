class UsersController < ApplicationController

  before_action only: [:index] do
    skip_policy_scope
  end

  def index
    @users = User.includes(:roles).all
  end

  def show
    @user = User.includes(:roles).find(params[:id])
    authorize @user
  end

  def edit
    @user = User.includes(:roles).find(params[:id])
    authorize @user
  end

  def update

  end

end
