package modelos;

public class Insumo {
    private String id;
    private String nombre;
    private double cantidad;

    public Insumo() {}

    public Insumo(String nombre, double cantidad) {
        this.nombre = nombre;
        this.cantidad = cantidad;
    }

    public void reabastecer(double cantidad) {
        this.cantidad += cantidad;
    }

    public void descontarUso(double cantidad) {
        this.cantidad -= cantidad;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public double getCantidad() { return cantidad; }
    public void setCantidad(double cantidad) { this.cantidad = cantidad; }
}