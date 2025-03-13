import java.security.PublicKey;
import java.util.ArrayList;

interface FactoriaCarreraYBicicleta {

    public Carrera  crearCarrera();

    public Bicicleta crearBicicleta();  
}


abstract class Carrera {
    ArrayList<Bicicleta> numbicicletas = new ArrayList<>();

    public void anadirBicicleta(Bicicleta bicicleta){
        numbicicletas.add(bicicleta);
    }
}

abstract class Bicicleta {
    int id;

    public Bicicleta(int id){
        this.id = id;
    }
}

//Crear la carrera y bicicleta de carretera
class CarreraCarretera extends Carrera {
    public CarreraCarretera(){}

}

class BicicletaCarretera extends Bicicleta {
    public BicicletaCarretera(int id){
        super(id);
    }

}

//Crear la carrera y bicicleta de montaña
class CarreraMontana extends Carrera {
    public CarreraMontana(){}
}

class BicicletaMontana extends Bicicleta {
    public BicicletaMontana(int id){
        super(id);
    }
}


class FactoriaCarretera implements FactoriaCarreraYBicicleta {

    @Override
    public Carrera crearCarrera(){

    }

    @Override
    public Bicicleta crearBicicleta(){
        
    }

}

class FactoriaMontana implements FactoriaCarreraYBicicleta { 

}