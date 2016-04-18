class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_empresa
  def current_empresa
    @current_empresa ||= Empresady.find(session[:empresa_id]) if session[:empresa_id]
  end

  def require_empresa
    redirect_to '/login' unless current_empresa
  end
end
