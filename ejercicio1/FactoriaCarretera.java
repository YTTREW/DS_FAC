package ejercicio1;

public class FactoriaCarretera implements FactoriaCarreraYBicicleta {
    @Override
    public Carrera crearCarrera(int numBicicletas){
        return new CarreraCarretera(numBicicletas);
    }

    @Override
    public Bicicleta crearBicicleta(int id){
        return new BicicletaCarretera(id);   
    }
}