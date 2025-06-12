class Receta < ApplicationRecord
  self.table_name = "recetas"
  
  validates :nombre, presence: true
  validates :ingredientes, presence: true
  validates :instrucciones, presence: true
  validates :dificultad, presence: true, inclusion: { in: 1..10 }
  validates :tipo_comida, presence: true, inclusion: { in: %w[dulce salado] }
end