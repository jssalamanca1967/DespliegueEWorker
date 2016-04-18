class PagesController < ApplicationController
  def home

    @empresaEjm = Empresady.new(:nombre_empresa => "EmpresaEjemplo")
    @empresaEjm.save
    @proyectoEjm = @empresaEjm.proyectos.create(:nombre => "ProyectoEjm")
    @proyectoEjm.empresa = @empresaEjm
    @proyectoEjm.save
    @disenioEjm = @proyectoEjm.disenios.create(:nombre_diseniador => "DiseniadorEjm")
    @disenioEjm.proyecto = @proyectoEjm
    @disenioEjm.save

    @empresas = Empresady.all

    @proyectoEjm.empresa_ids.each do |m|
      puts("asdasdasdasdasdasdasdasd " + m )

      if(@empresaEjm.id == m)
        puts("Leeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeel")
      end

    end



    @empresas.each do |e|
      puts("----- " + e.id)
    end

  end

  def about

    SenderMail.enviarHeroku().deliver_now
  end
end
