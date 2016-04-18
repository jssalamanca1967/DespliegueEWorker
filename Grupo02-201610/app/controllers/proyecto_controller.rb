class ProyectoController < ApplicationController

  $proyecto_a

  def index
    @proyectos = Proyectody.all
  end

  def show
    @proyecto = Proyectody.find(params[:id])
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    ### NO ORDENA
    @disenios = @proyecto.disenios.where(estado: "Disponible")#.order(created_at: :desc)#.paginate(page: params[:page])
  end

  def new
    @proyecto = Proyecto.new
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
  end

  def create
    @proyecto_nuevo = Proyecto.new(proyecto_params)
    if($proyecto_a == nil)
      @empresa = Empresady.find(current_empresa.id)
      @proyecto = @empresa.proyectos.create(proyecto_params)
      @proyecto.empresa = @empresa

      if(@proyecto.save)
        redirect_to "/empresas/#{@empresa.nombre_empresa}"
      else
        render 'new'
      end
    else
      self.update(@proyecto_nuevo)
    end
  end

  def edit
    @proyecto2 = Proyectody.find(params[:id])
    $proyecto_a = @proyecto2
    @proyecto = Proyecto.new(:nombre => @proyecto2.nombre ,:descripcion => @proyecto2.descripcion ,:valor_pagar => @proyecto2.valor_pagar)
  end

  def update(proyecto_nuevo)
    @proyecto_nuevo = proyecto_nuevo

    @proyecto = $proyecto_a

    @proyecto.nombre = @proyecto_nuevo.nombre
    @proyecto.descripcion = @proyecto_nuevo.descripcion
    @proyecto.valor_pagar = @proyecto_nuevo.valor_pagar

    @empresa = @proyecto.empresa
    if @proyecto.save
      $proyecto_a = nil
      redirect_to "/empresas/#{@empresa.nombre_empresa}"
    else
      render 'edit'
    end
  end

  def destroy
    @proyecto = Proyectody.find(params[:id])
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    @proyecto.disenios.each do |d|
      d.delete
    end
    @proyecto.delete
    #Proyectody.delete(@proyecto)
    redirect_to "/empresas/#{@empresa.nombre_empresa}"
  end

  private
    def proyecto_params
      params.require(:proyecto).permit(:nombre, :descripcion, :valor_pagar)
    end
  private
    def proyecto_params2
      params.require(:proyecto).permit(:nombre, :descripcion, :valor_pagar, :empresa_ids)
    end

end
