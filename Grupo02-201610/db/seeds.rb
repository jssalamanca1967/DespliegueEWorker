# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

var = 1
while var < 10
  e = Empresa.create(email: "bla#{var}@gmail.com", nombre_empresa: "bla#{var}", password_digest: 'asdf1234')
  var2 = 1
  while var2 < 10
    p = Proyecto.create(descripcion: "ashsdagjsda#{var2}", nombre: "Proyecto #{var2}", valor_pagar: 12, empresa_id: e.id)

    var3 = 1
    while var3 < 10

      Disenio.create(nombre_diseniador: "ashsdagjsda#{var3}", apellido_diseniador: "Proyecto #{var3}",
                      precio_solicitado: 15, estado: 'Disponible', email_diseniador: "Diseniador #{var3}",
                      proyecto_id: p.id)
      var3 = var3 + 1
    end

    var2 = var2 + 1
  end

  var = var + 1
end
