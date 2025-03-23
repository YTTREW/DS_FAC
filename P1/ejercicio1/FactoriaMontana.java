package ejercicio1;

import java.util.ArrayList;

public class FactoriaMontana implements FactoriaCarreraYBicicleta { 
    @Override
    //Crear objeto de tipo Carrera de Montaña
    public Carrera crearCarrera(ArrayList<Bicicleta> bicicletas){
        return new CarreraMontana(bicicletas);
    }

    @Override
    //Crear objeto de tipo Bicicleta de Montaña
    public Bicicleta crearBicicleta(int id){
        return new BicicletaMontana(id);    
    }
}