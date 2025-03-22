package ejercicio4;

public class Message {
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