class DropRecetaTable < ActiveRecord::Migration[8.0]
  def change
      drop_table :receta
  end
end
