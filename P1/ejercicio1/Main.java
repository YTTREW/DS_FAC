package ejercicio1;

import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        // Solicitar nº bicicletas por parametro
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingrese la cantidad de bicicletas para la carrera: ");
        int numBicicletas = scanner.nextInt();

        // Crear la factoría de carretera y montaña
        FactoriaCarreraYBicicleta factoriaCarretera = new FactoriaCarretera();
        FactoriaCarreraYBicicleta factoriaMontana = new FactoriaMontana();

        // Crear array de bicicletas para cada carrera
        ArrayList<Bicicleta> bicicletasCarretera = new ArrayList<>();
        ArrayList<Bicicleta> bicicletasMontana = new ArrayList<>();

        // Asignar bicicletas de carretera
        for (int i = 0; i < numBicicletas; i++) {
            Bicicleta biciCarretera = factoriaCarretera.crearBicicleta(i);
            bicicletasCarretera.add(biciCarretera);
        }

        // Asignar bicicletas de montaña
        for (int i = 0; i < numBicicletas; i++) {
            Bicicleta biciMontana = factoriaMontana.crearBicicleta(i);
            bicicletasMontana.add(biciMontana);
        }

        // Crear los dos tipos de carreras
        Carrera carreraCarretera = factoriaCarretera.crearCarrera(bicicletasCarretera);
        Carrera carreraMontana = factoriaMontana.crearCarrera(bicicletasMontana);
        carreraCarretera.start();
        carreraMontana.start();

        // Espera de 2s para no acceder al while
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Mostrar el nº de bicicletas restantes cada 10 segundos
        while (carreraCarretera.isAlive() || carreraMontana.isAlive()) {

            System.out
                    .println("Número de bicicletas en la carrera de carretera: " + carreraCarretera.bicicletas.size());
            System.out.println("Número de bicicletas en la carrera de montaña: " + carreraMontana.bicicletas.size());
            System.out.println("-------------------------------------------------");
            try {
                Thread.sleep(8000); // Pausa de 8 segundos
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        try {
            carreraCarretera.join();
            carreraMontana.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Las carreras de montaña y carretera han finalizado.");

        // Cerar el scanner
        scanner.close();
    }
}
