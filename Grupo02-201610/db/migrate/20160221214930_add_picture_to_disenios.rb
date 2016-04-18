class AddPictureToDisenios < ActiveRecord::Migration
  def change
    add_column :disenios, :picture, :string
  end
end
