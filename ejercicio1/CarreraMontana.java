package ejercicio1;
import java.util.ArrayList;

class CarreraMontana extends Carrera {
    
    public CarreraMontana(int numBicicletas) {
        super(new ArrayList<>(), "montaña", 0.2);
        for (int i = 0; i < numBicicletas; i++) {
            bicicletas.add(new BicicletaCarretera(i));
        }    
    }
}
