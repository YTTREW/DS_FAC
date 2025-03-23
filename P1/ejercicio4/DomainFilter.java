package ejercicio4;

public class DomainFilter implements Filter {
    // Lista privada de sufijos de dominio permitidos
    private static final String[] VALID_DOMAINS = { "@gmail.com", "@hotmail.com" };

    @Override
    public void execute(Message message) throws Exception {
        String correo = message.getEmail();
        boolean isValidDomain = false;

        // Verifica si el correo termina con uno de los sufijos válidos
        for (String domain : VALID_DOMAINS) {
            if (correo.endsWith(domain)) {
                isValidDomain = true;
                break;
            }
        }

        if (!isValidDomain) {
            throw new Exception("Correo inválido: dominio incorrecto");
        }
    }
}