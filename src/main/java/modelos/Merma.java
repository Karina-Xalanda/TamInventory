package modelos;

import java.util.Date;

public class Merma {
    private String id;
    private Date fecha;
    private String tipo;       // COMIDO, FIADO, SOBRANTE
    private String descripcion;
    private double valorMerma;
    private double cantidadMerma;
    private String idProducto;

    public Merma() {
        this.fecha = new Date();
    }

    public Merma(String tipo, String descripcion, double valorMerma, double cantidadMerma, String idProducto) {
        this.fecha = new Date();
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.valorMerma = valorMerma;
        this.cantidadMerma = cantidadMerma;
        this.idProducto = idProducto;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public double getValorMerma() { return valorMerma; }
    public void setValorMerma(double valorMerma) { this.valorMerma = valorMerma; }
    public double getCantidadMerma() { return cantidadMerma; }
    public void setCantidadMerma(double cantidadMerma) { this.cantidadMerma = cantidadMerma; }
    public String getIdProducto() { return idProducto; }
    public void setIdProducto(String idProducto) { this.idProducto = idProducto; }
}