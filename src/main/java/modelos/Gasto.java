package modelos;

import java.util.Date;

public class Gasto {
    private String id;
    private Date fecha;
    private String tipo;       // INSUMO, SALARIO
    private String descripcion;
    private double monto;

    public Gasto() {
        this.fecha = new Date();
    }

    public Gasto(String tipo, String descripcion, double monto) {
        this.fecha = new Date();
        this.tipo = tipo;
        this.descripcion = descripcion;
        this.monto = monto;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }
}