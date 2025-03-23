package ejercicio4;

public class PasswordSpecialCharacterFilter implements Filter {
    // Lista privada de caracteres especiales permitidos
    private static final String SPECIAL_CHARACTERS = "!@#$%^&*(),.?\":{}|<>";

    @Override
    public void execute(Message message) throws Exception {
        String password = message.getPassword();
        if (!password.matches(".*[" + SPECIAL_CHARACTERS + "].*")) {
            throw new Exception("Contraseña inválida: debe contener al menos un carácter especial");
        }
    }
}
