package modelos;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Venta {
    private String id;
    private Date fecha;
    private double totalVenta;
    private List<DetalleVenta> detalles;

    public Venta() {
        this.fecha = new Date();
        this.detalles = new ArrayList<>();
    }

    public void agregarDetalle(DetalleVenta detalle) {
        detalles.add(detalle);
    }

    public double calcularTotal() {
        totalVenta = 0;
        for (DetalleVenta d : detalles) {
            totalVenta += d.calcularSubtotal();
        }
        return totalVenta;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public double getTotalVenta() { return totalVenta; }
    public void setTotalVenta(double totalVenta) { this.totalVenta = totalVenta; }
    public List<DetalleVenta> getDetalles() { return detalles; }
    public void setDetalles(List<DetalleVenta> detalles) { this.detalles = detalles; }
}