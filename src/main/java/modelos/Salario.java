package modelos;

public class Salario {
    private String id;
    private double cantidad;
    private String idTrabajador;

    public Salario() {}

    public Salario(double cantidad, String idTrabajador) {
        this.cantidad = cantidad;
        this.idTrabajador = idTrabajador;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public double getCantidad() { return cantidad; }
    public void setCantidad(double cantidad) { this.cantidad = cantidad; }
    public String getIdTrabajador() { return idTrabajador; }
    public void setIdTrabajador(String idTrabajador) { this.idTrabajador = idTrabajador; }
}