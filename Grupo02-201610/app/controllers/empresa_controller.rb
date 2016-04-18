class EmpresaController < ApplicationController
  #before_action :require_empresa, only: [:index, :show, :edit, :update]

  def to_param
    "#{nombre_empresa}"
  end

  def index
    @empresas = Empresady.all
  end

  def new
    @new_empresa = Empresa.new
  end

  def create
    @empresa = Empresady.new(empresa_params)
    @empresa.created_at = DateTime.now
    array = @empresa.nombre_empresa.scan(/\w+/)
    str = ""
    array.each { |x| str += x + "-" }

    str[str.length - 1] = ""

    puts("---------------------------------------------- " +  @empresa.nombre_empresa)

    @empresa2 = Empresady.where(nombre_empresa_real: @empresa.nombre_empresa).all

    puts (@empresa2.size)

    if @empresa2.size > 0
      str += "" + @empresa2.size.to_s
    end

    @empresa.nombre_empresa_real = @empresa.nombre_empresa

    @empresa.nombre_empresa = str

    @empresasEMail = Empresady.where(email: @empresa.email).all

    if @empresasEMail.size > 0
      puts("Ya existe una empresa con el email #{@empresa.email} empresa ya existe")
      redirect_to '/signup'
    else
      if @empresa.save
        session[:empresa_id] = @empresa.id
        redirect_to '/'
      else
        redirect_to '/signup'
      end
    end
	end

  def show
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    @proyectos = @empresa.proyectos.all#.paginate(page: params[:page])

  end

  def edit
    @empresa = current_empresa
  end

  def update
    @empresa = current_empresa
    if @empresa.update_attributes(empresa_params)
      redirect_to(:action => 'show', :nombre_empresa => @empresa.nombre_empresa)
    else
      render 'edit'
    end
  end

  private
    def empresa_params
      # params.require(:empresa).permit(:nombre_empresa, :email)
      params.require(:empresa).permit(:nombre_empresa, :email, :password_digest)
    end

end
