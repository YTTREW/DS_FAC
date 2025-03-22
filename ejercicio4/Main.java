package ejercicio4;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        AuthTarget authTarget = new AuthTarget(); 
        FilterManager filterManager = new FilterManager(authTarget);

        
        filterManager.addFilter(new FilterMail());
        filterManager.addFilter(new FilterDomain());

        Scanner scanner = new Scanner(System.in);

        System.out.print("Introduce el correo: ");
        String email = scanner.nextLine();

        System.out.print("Introduce la contraseña: ");
        String password = scanner.nextLine();

        Client client = new Client(filterManager);
        client.sendCredentials(email, password);

        scanner.close();
    }
}
