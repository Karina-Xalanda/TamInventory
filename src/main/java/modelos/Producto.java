package modelos;

public class Producto {
    private String id;
    private String nombre;
    private String descripcion;
    private String categoria;
    private double precioVenta;

    public Producto() {}

    public Producto(String nombre, String descripcion, String categoria, double precioVenta) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.precioVenta = precioVenta;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    public double getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(double precioVenta) { this.precioVenta = precioVenta; }
}