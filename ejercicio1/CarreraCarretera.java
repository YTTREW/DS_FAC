package ejercicio1;

import java.util.ArrayList;

public class CarreraCarretera extends Carrera {
    
    public CarreraCarretera(int numBicicletas) {
        super(new ArrayList<>(), "carretera", 0.1);
        for (int i = 0; i < numBicicletas; i++) {
            bicicletas.add(new BicicletaCarretera(i));
        }    
    }
      
}
