class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  before_action only: [:index] do
    skip_policy_scope
  end

  def index
    @users = User.includes(:roles).all
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
    build_roles(@user)
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      build_roles(@user)
      render :edit
    end
  end

  private

  def build_roles(user)
    build_roles = Role.all - user.roles
    build_roles.each do |role|
      user.users_roles.build(role: role)
    end
  end

  def set_user
    @user = User.includes(:roles).find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(policy(User).permitted_attributes)
  end
end
