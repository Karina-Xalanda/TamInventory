package modelos;

public class Producto {

    private String id;
    private String nombre;
    private String descripcion;
    private String categoria;
    private double precioVenta;
    private String imagenUrl; // campo nuevo: nombre del archivo de imagen

    public Producto() {}

    public Producto(String nombre, String descripcion, String categoria,
                    double precioVenta, String imagenUrl) {
        this.nombre      = nombre;
        this.descripcion = descripcion;
        this.categoria   = categoria;
        this.precioVenta = precioVenta;
        this.imagenUrl   = imagenUrl;
    }

    public String getId()                        { return id; }
    public void   setId(String id)               { this.id = id; }
    public String getNombre()                    { return nombre; }
    public void   setNombre(String nombre)       { this.nombre = nombre; }
    public String getDescripcion()               { return descripcion; }
    public void   setDescripcion(String v)       { this.descripcion = v; }
    public String getCategoria()                 { return categoria; }
    public void   setCategoria(String v)         { this.categoria = v; }
    public double getPrecioVenta()               { return precioVenta; }
    public void   setPrecioVenta(double v)       { this.precioVenta = v; }
    public String getImagenUrl()                 { return imagenUrl; }
    public void   setImagenUrl(String imagenUrl) { this.imagenUrl = imagenUrl; }
}