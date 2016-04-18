class CreateEmpresas < ActiveRecord::Migration
  def change
    create_table :empresas do |t|
      t.string :password_digest
      t.string :email
      t.string :nombre_empresa
      t.string :nombre_empresa_real

      t.timestamps null: false
    end
  end
end
