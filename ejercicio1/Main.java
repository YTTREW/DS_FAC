package ejercicio1;

public class Main {

    public static void main(String[] args) {
        // Creamos la factoría de carretera y montaña
        FactoriaCarreraYBicicleta factoriaCarretera = new FactoriaCarretera();
        FactoriaCarreraYBicicleta factoriaMontana = new FactoriaMontana();

        // Creamos las carreras con un número de bicicletas
        Carrera carreraCarretera = factoriaCarretera.crearCarrera(20);  // Carrera de carretera con 10 bicicletas
        Carrera carreraMontana = factoriaMontana.crearCarrera(20);      // Carrera de montaña con 10 bicicletas
        carreraCarretera.start();
        carreraMontana.start();

        try {
            // Espera a que ambas carreras terminen
            carreraCarretera.join();
            carreraMontana.join();
           } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println(" Las carreras han terminado.");
    }
}
