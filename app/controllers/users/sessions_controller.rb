class Users::SessionsController < Devise::SessionsController
  rescue_from Net::LDAP::Error, :with => :ldap_error_handler
  before_action :skip_authorization
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private

  def ldap_error_handler
    flash[:error] = "Unable to authenticate user."
    redirect_to unauthenticated_root_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username], except: [:email])
  end
end
