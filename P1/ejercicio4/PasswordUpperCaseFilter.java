package ejercicio4;

public class PasswordUpperCaseFilter implements Filter {
    @Override
    public void execute(Message message) throws Exception {
        String password = message.getPassword();
        if (password == null || !password.matches(".*[A-Z].*")) {
            throw new Exception("Contraseña inválida: debe contener al menos una mayúscula");
        }
    }
}
