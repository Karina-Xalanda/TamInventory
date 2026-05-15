package modelos;

public class Trabajador {
    private String id;
    private String nombre;
    private String telefono;

    public Trabajador() {}

    public Trabajador(String nombre, String telefono) {
        this.nombre = nombre;
        this.telefono = telefono;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
}
