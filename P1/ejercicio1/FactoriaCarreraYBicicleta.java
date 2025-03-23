package ejercicio1;

import java.util.ArrayList;

public interface FactoriaCarreraYBicicleta {
    //Crear objeto de tipo Carrera
    public Carrera crearCarrera(ArrayList<Bicicleta> bicicletas);
    //Crear objeto de tipo Bicicleta
    public Bicicleta crearBicicleta(int id);  
}