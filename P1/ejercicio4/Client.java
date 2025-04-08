package ejercicio4;

public class Client {
    private FilterManager filterManager;

    public Client(FilterManager filterManager) {
        this.filterManager = filterManager;
    }

    public void sendCredentials(String correo, String contraseña) {
        Message message = new Message(correo, contraseña);
        try {
            filterManager.authenticate(message);
        } catch (Exception e) {
            System.out.println("Error -> " + e.getMessage());
        }
    }
}
