class CreateReceta < ActiveRecord::Migration[8.0]
  def change
    create_table :receta do |t|
      t.string :nombre
      t.text :ingredientes
      t.text :instrucciones

      t.timestamps
    end
  end
end
