package ejercicio4;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        AuthTarget authTarget = new AuthTarget();
        FilterManager filterManager = new FilterManager(authTarget);

        filterManager.addFilter(new MailFilter());
        filterManager.addFilter(new DomainFilter());
        filterManager.addFilter(new PasswordLengthFilter());
        filterManager.addFilter(new PasswordUpperCaseFilter());
        filterManager.addFilter(new PasswordSpecialCharacterFilter());

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
