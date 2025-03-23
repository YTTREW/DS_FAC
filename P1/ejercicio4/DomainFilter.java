package ejercicio4;

public class DomainFilter implements Filter {
    @Override
    public void execute(Message message) throws Exception {
        String correo = message.getCorreo();
        if (!correo.endsWith("@gmail.com") && !correo.endsWith("@hotmail.com")) {
            throw new Exception("Correo inválido: dominio incorrecto");
        }
    }
}