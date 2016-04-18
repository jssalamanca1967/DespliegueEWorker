class SessionsController < ApplicationController
  def new

  end

  def create
    @empresa = Empresady.find_by_email(params[:session][:email])
    puts("-------------------------- " + params[:session][:password])
    if @empresa && @empresa.password_digest == (params[:session][:password])
      session[:empresa_id] = @empresa.id
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:empresa_id] = nil
    redirect_to '/'
  end
end
