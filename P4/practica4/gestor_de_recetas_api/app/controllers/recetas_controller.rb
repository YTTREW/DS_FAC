class RecetasController < ApplicationController
    def index
        @recetas = Recetum.all
        render json: @recetas
    end

    def create
        @receta = Recetum.new(receta_params)
        if @receta.save
            render json: @receta, status: :created
        else
            render json: @receta.errors, status: :unprocessable_entity
        end
    end

    def update
        @receta = Recetum.find(params[:id])
        if @receta.update(receta_params)
            render json: @receta
        else
            render json: @receta.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @receta = Recetum.find(params[:id])
        if @receta.destroy
            head :ok
        else
            render json: { error: 'Error al eliminar' }, status: :unprocessable_entity
        end
    end

    private

    def receta_params
        params.require(:receta).permit(:nombre, :ingredientes, :dificultad, :tipo)
    end
end
