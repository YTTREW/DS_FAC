package ejercicio4;
class Message {
    String correo;
    String contrasena;

    public Message ( String correo, String contrasena ) {
        this.correo = correo;
        this.contrasena = contrasena;
    }

    public String getCorreo() {
        return correo;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setCorreo( String correo ) {
        this.correo = correo;
    }

    public void setContrasena( String contrasena ) {
        this.contrasena = contrasena;
    }
}

interface Filter {
    void execute ( Message message ) throws Exception;       
}

class FilterCharacter implements Filter {
    @Override
    public void execute(Message message) throws Exception {
        String correo = message.getCorreo();
        if (correo == null || !correo.matches("^[^@]+@.+\\..+$")) {
            throw new Exception("Correo inválido: formato incorrecto");
        }
    }
}

class FilterDomain implements Filter{
    @Override
    public void execute(Message message) throws Exception {
        String correo = message.getCorreo();
        if (!correo.endsWith("@gmail.com") && !correo.endsWith("@hotmail.com")) {
            throw new Exception("Correo inválido: dominio incorrecto");
        }
    }
}