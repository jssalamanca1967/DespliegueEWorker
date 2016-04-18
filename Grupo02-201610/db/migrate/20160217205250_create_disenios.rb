class CreateDisenios < ActiveRecord::Migration
  def change
    create_table :disenios do |t|
      t.string :nombre_diseniador
      t.string :apellido_diseniador
      t.string :estado
      t.string :email_diseniador
      t.integer :precio_solicitado
      t.references :proyecto

      t.timestamps null: false #Aquí ya queda la fecha de creación, se obtiene con .created_at
    end
  end
end
