package ejercicio1;

import java.util.ArrayList;

public abstract class Carrera extends Thread{
    ArrayList<Bicicleta> bicicletas = new ArrayList<>();
    String tipoCarrera;
    double tasaRetirada;

    public Carrera(ArrayList<Bicicleta> bicicletas, String tipoCarrera, double tasaRetirada){
        this.bicicletas = bicicletas;
        this.tipoCarrera = tipoCarrera;
        this.tasaRetirada = tasaRetirada;
    }

    public void retirarBicicletas(){
        
        int retiradas = (int) (bicicletas.size() * tasaRetirada);
        
        for (int i = 0; i < retiradas; i++) {
            bicicletas.remove(bicicletas.size() - 1);
        }

        System.out.println(" Bicicletas retiradas durante la carrera de " + tipoCarrera + ":"  + retiradas);
        System.out.println(" La tasa de abandono ha sido del: " + tasaRetirada*100 + "%.");
    }

    public void run() {

        System.out.println("Iniciando la carrera de tipo "+ tipoCarrera + " con " + bicicletas.size() + " bicicletas");
        try {
            Thread.sleep(10000); // Duración de 60 segundos
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        retirarBicicletas();

    }
}
