package ejercicio1;

import java.util.ArrayList;

public abstract class Carrera extends Thread{
    ArrayList<Bicicleta> bicicletas = new ArrayList<>();
    String tipoCarrera;
    double tasaRetirada;

    //Constructor para crear Carrera
    public Carrera(ArrayList<Bicicleta> bicicletas, String tipoCarrera, double tasaRetirada){
        this.bicicletas = bicicletas;
        this.tipoCarrera = tipoCarrera;
        this.tasaRetirada = tasaRetirada;
    }

    //Metodo para retirar un porcentaje de bicicletas
    public void retirarBicicletas(){
        int retiradas = (int) (bicicletas.size() * tasaRetirada);
        
        for (int i = 0; i < retiradas; i++) {
            bicicletas.remove(bicicletas.size() - 1);
        }

        System.out.println("Bicicletas retiradas durante la carrera de " + tipoCarrera + ": "  + retiradas);
        System.out.println("La tasa de abandono ha sido del: " + tasaRetirada*100 + "%.");
        System.out.println("-------------------------------------------------");
    }

    //Metodo run para ejecutar las carreras
    public void run() {
        System.out.println("Iniciando la carrera de tipo "+ tipoCarrera + " con " + bicicletas.size() + " bicicletas");
        int tiempoAleatorio = (int) (Math.random() * 50000);

        try {
            Thread.sleep(tiempoAleatorio);
            retirarBicicletas();
            Thread.sleep(60000 - tiempoAleatorio);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
