package ejercicio1;

import java.util.ArrayList;

public class FactoriaCarretera implements FactoriaCarreraYBicicleta {
    @Override
    //Crear objeto de tipo Carrera de Carretera
    public Carrera crearCarrera(ArrayList<Bicicleta> bicicletas){
        return new CarreraCarretera(bicicletas);
    }

    @Override
    //Crear objeto de tipo Bicicleta de Carretera
    public Bicicleta crearBicicleta(int id){
        return new BicicletaCarretera(id);   
    }
}