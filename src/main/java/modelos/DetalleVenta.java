package modelos;

public class DetalleVenta {
    private String id;
    private int cantidad;
    private double precioUnitario;
    private String idProducto;

    public DetalleVenta() {}

    public DetalleVenta(int cantidad, double precioUnitario, String idProducto) {
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.idProducto = idProducto;
    }

    public double calcularSubtotal() {
        return cantidad * precioUnitario;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
    public String getIdProducto() { return idProducto; }
    public void setIdProducto(String idProducto) { this.idProducto = idProducto; }
}