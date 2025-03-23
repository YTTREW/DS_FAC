package ejercicio4;

public class AuthTarget {
    public void authenticate(Message message) {
        System.out.println("Correcta autenticación para el correo: " + message.getEmail());
    }
}
