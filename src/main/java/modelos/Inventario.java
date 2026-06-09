package modelos;

import java.util.Date;

public class Inventario {

    private String id;
    private String idProducto;
    private String nombreProducto;
    private int    stockInicial;    // cuantos se hicieron al inicio del dia
    private int    stockDisponible; // cuantos quedan disponibles ahora
    private Date   fecha;


    public Inventario() {
        this.fecha = new Date();
    }


    public Inventario(String idProducto, String nombreProducto, int stockInicial) {
        this.idProducto      = idProducto;
        this.nombreProducto  = nombreProducto;
        this.stockInicial    = stockInicial;
        this.stockDisponible = stockInicial; // al inicio disponible =todo lo producido
        this.fecha           = new Date();
    }

    public String getEstado() {
        if (stockDisponible <= 0)  return "AGOTADO";
        if (stockDisponible <= 10) return "CRITICO";
        if (stockDisponible <= 20) return "BAJO";
        return "OPTIMO";
    }

    public String getId()    { return id; }
    public void   setId(String id)    { this.id = id; }
    public String getIdProducto()     { return idProducto; }
    public void   setIdProducto(String v)   { this.idProducto = v; }
    public String getNombreProducto()        { return nombreProducto; }
    public void   setNombreProducto(String v)  { this.nombreProducto = v; }
    public int    getStockInicial()    { return stockInicial; }
    public void   setStockInicial(int v)  { this.stockInicial = v; }
    public int    getStockDisponible()    { return stockDisponible; }
    public void   setStockDisponible(int v) { this.stockDisponible = v; }
    public Date   getFecha()     { return fecha; }
    public void   setFecha(Date fecha)   { this.fecha = fecha; }
}