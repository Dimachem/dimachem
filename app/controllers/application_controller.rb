class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def get_query(cookie_key)
    cookies.delete(cookie_key) if params[:clear_query]
    cookies[cookie_key] = params[:q].to_json if params[:q]
    @query = params[:q].presence || JSON.load(cookies[cookie_key])
  end
end
