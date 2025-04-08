package ejercicio4;

public class PasswordLengthFilter implements Filter {
    private static final int MIN_LENGTH = 5;
    private static final int MAX_LENGTH = 50;

    @Override
    public void execute(Message message) throws Exception {
        String password = message.getPassword();
        if (password.length() < MIN_LENGTH || password.length() > MAX_LENGTH) {
            throw new Exception("Contraseña inválida: longitud incorrecta");
        }
    }
}
