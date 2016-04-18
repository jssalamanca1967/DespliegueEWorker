#!/usr/bin/env ruby
class DisenioController < ApplicationController
  #before_action :require_empresa, only: [:index, :show]
  $proyecto_actual
  $empresa_actual
  $disenio_edit

  def index
    @disenios = Disenio.all
  end

  def show
    @disenio = Diseniody.find(params[:id_disenio])
    @proyecto = Proyectody.find(params[:id_proyecto])
    @empresa = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
  end

  def new
    @disenio = Disenio.new
    $proyecto_actual = Proyectody.find(params[:id_proyecto])
    @proyecto = $proyecto_actual
    $empresa_actual = Empresady.find_by_nombre_empresa(params[:nombre_empresa])
    @empresa = $empresa_actual
  end

  def create
    connection = Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => ENV["AWSAccessKeyId"],
      :aws_secret_access_key    => ENV["AWSSecretKey"],
      :region                   => "us-west-2",
      :persistent               => true
    })
    directorio=connection.directories.get(ENV["AWSBucket"])

    @disenio = Disenio.new(disenio_params2)
    if($disenio_nuevo == nil)
      
      @proyecto = $proyecto_actual
      @empresa = $empresa_actual
      
      @disenio2 = $proyecto_actual.disenios.create(:nombre_diseniador => @disenio.nombre_diseniador ,:apellido_diseniador => @disenio.apellido_diseniador ,:estado => @disenio.estado ,:email_diseniador => @disenio.email_diseniador ,:precio_solicitado => @disenio.precio_solicitado)
      @disenio2.picture = "#{@disenio.picture.url}"
      puts("------------- URL: " + @disenio2.picture)
      @disenio2.proyecto = $proyecto_actual
      if(@disenio2.save)
        new_file_bucket = "#{@disenio2.id}#{@disenio.picture}"
        s3_file_object = directorio.files.create(:key => new_file_bucket, :body => File.open("#{@disenio.picture.path}"), :acl => "public-read")
	@disenio2.picture = new_file_bucket
	@disenio2.save
        enviarCola(@disenio, @disenio2)
        redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
      else
        render 'new'
      end
    else
      update(@disenio)
    end
  end

  def edit
    @disenio = Disenio.find(params[:id_disenio])
    $disenio_edit = @disenio
    @proyecto = @disenio.proyecto
    @empresa = @proyecto.empresa
  end

  def update(disenio)
    @disenio_nuevo = disenio
    @disenio = $disenio_edit

    @disenio.nombre_diseniador = @disenio_nuevo.nombre_diseniador
    @disenio.apellido_diseniador = @disenio_nuevo.apellido_diseniador
    @disenio.estado = @disenio_nuevo.estado
    @disenio.email_diseniador = @disenio_nuevo.email_diseniador
    @disenio.precio_solicitado = @disenio_nuevo.precio_solicitado

    @proyecto = @disenio.proyecto
    @empresa = @proyecto.empresa
    if @disenio.save
      $disenio_edit = nil
      redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
    else
      render 'edit'
    end
  end

  def destroy
    @disenio = Disenio.find(params[:id_disenio])
    @proyecto = Proyecto.find(@disenio.proyecto_id)
    @empresa = Empresa.find(@proyecto.empresa_id)
    Disenio.delete(@disenio)
    redirect_to "/empresas/#{@empresa.nombre_empresa}/#{@proyecto.id}"
  end

  def self.prueba
    @disenios = Disenio.where(estado: "En proceso")
    @disenios.each do |d|
      procesarImagen(d)
    end
    print("Llego hasta aqui")
    SenderMail.prueba.deliver_now
  end

  private
    def disenio_params
      params.require(:disenio).permit(:nombre_diseniador, :apellido_diseniador, :estado, :precio_solicitado, :email_diseniador)
    end
  private
    def disenio_params2
      params.require(:disenio).permit(:nombre_diseniador, :apellido_diseniador, :estado, :precio_solicitado, :email_diseniador, :proyecto_id, :picture)
    end
  private
    def enviarCola(disenio, disenio2)
      @disenio = disenio
      @disenio2 = disenio2

      print("A COLA\n")
      iddisenio = "#{@disenio2.id}"
      direccion = "#{@disenio2.id}#{@disenio.picture}"
      fechacreacion = "#{@disenio2.created_at}"
      nombrediseniador = "#{@disenio.nombre_diseniador}"
      correo = "#{@disenio.email_diseniador}"
      mensaje = "#{@disenio.nombre_diseniador} ::: #{@disenio2.created_at}"

      # ENVIAR A COLA
      sqs = Aws::SQS::Client.new(
          region: 'us-west-2',
          access_key_id: ENV['AWSAccessKeyId'],
          secret_access_key: ENV['AWSSecretKey']
      )

      aEnviar = { d_id: "#{iddisenio}", d_direccion: "#{direccion}", d_fechacreacion: "#{fechacreacion}", d_nombrediseniador: "#{nombrediseniador}", d_correo: "#{@disenio.email_diseniador}" }.to_json

      cola = sqs.send_message({
        queue_url: "https://sqs.us-west-2.amazonaws.com/364477857468/mensajes",
        message_body: aEnviar, # required
        delay_seconds: 1,
      })
    end
end
