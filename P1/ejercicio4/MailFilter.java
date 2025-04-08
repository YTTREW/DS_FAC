package ejercicio4;

public class MailFilter implements Filter {
    @Override
    public void execute(Message message) throws Exception {
        String correo = message.getEmail();
        if (correo == null || !correo.matches("^[^@]+@.+\\..+$")) {
            throw new Exception("Correo inválido: formato incorrecto, debe contener texto");
        }
    }
}