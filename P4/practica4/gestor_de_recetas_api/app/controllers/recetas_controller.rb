class RecetasController < ApplicationController
  def index
    @recetas = Receta.all
    render json: @recetas.as_json(
      only: [:id, :nombre, :ingredientes, :instrucciones, :dificultad, :tipo_comida, :created_at]
    )
  end

  def create
    @receta = Receta.new(receta_params)
    if @receta.save
      render json: @receta.as_json(
        only: [:id, :nombre, :ingredientes, :instrucciones, :dificultad, :tipo_comida, :created_at]
      ), status: :created
    else
      render json: @receta.errors, status: :unprocessable_entity
    end
  end

  def show
    @receta = Receta.find(params[:id])
    render json: @receta.as_json(
      only: [:id, :nombre, :ingredientes, :instrucciones, :dificultad, :tipo_comida, :created_at]
    )
  end

  def update
    @receta = Receta.find(params[:id])
    if @receta.update(receta_params)
      render json: @receta.as_json(
        only: [:id, :nombre, :ingredientes, :instrucciones, :dificultad, :tipo_comida, :created_at]
      )
    else
      render json: @receta.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @receta = Receta.find(params[:id])
    if @receta.destroy
      head :no_content
    else
      render json: { error: 'Error al eliminar' }, status: :unprocessable_entity
    end
  end

  private

  def receta_params
    params.require(:receta).permit(:nombre, :ingredientes, :instrucciones, :dificultad, :tipo_comida)
  end
end