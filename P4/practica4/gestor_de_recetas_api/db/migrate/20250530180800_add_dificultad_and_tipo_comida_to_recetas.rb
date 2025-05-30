class AddDificultadAndTipoComidaToRecetas < ActiveRecord::Migration[8.0]
  def change
    add_column :recetas, :dificultad, :integer
    add_column :recetas, :tipo_comida, :string
  end
end
