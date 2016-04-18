class CreateProyectos < ActiveRecord::Migration
  def change
    create_table :proyectos do |t|
      t.string :descripcion
      t.string :nombre
      t.integer :valor_pagar
      t.references :empresa
      t.string :id_falso

      t.timestamps null: false
    end
  end
end
