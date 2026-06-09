package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelos.Inventario;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class InventarioDAO {

    private final MongoCollection<Document> coleccion;

    public InventarioDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("inventario");
    }

    // ── CREATE / UPDATE  Registra el stock inicial de un producto para el dia actual.
    public void registrarStockDia(Inventario inv) {
        Document existente = coleccion.find(
                Filters.and(
                        Filters.eq("idProducto", inv.getIdProducto()),
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        ).first();

        if (existente != null) {
            // ya habia un registro hoy: actualiza con el nuevo stock
            coleccion.updateOne(
                    Filters.eq("_id", existente.getObjectId("_id")),
                    Updates.combine(
                            Updates.set("stockInicial",    inv.getStockInicial()),
                            Updates.set("stockDisponible", inv.getStockInicial())
                    )
            );
        } else {
            // primer registro del dia para este producto
            Document doc = new Document("idProducto",     inv.getIdProducto())
                    .append("nombreProducto",  inv.getNombreProducto())
                    .append("stockInicial",    inv.getStockInicial())
                    .append("stockDisponible", inv.getStockInicial())
                    .append("fecha",           inv.getFecha());
            coleccion.insertOne(doc);
        }
    }

    //  READ Devuelve el stock disponible de todos los productos para hoy.

    public List<Inventario> listarStockHoy() {
        List<Inventario> lista = new ArrayList<>();
        for (Document doc : coleccion.find(
                Filters.and(
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        )) {
            lista.add(documentToInventario(doc));
        }
        return lista;
    }


     //Busca el stock de hoy de un producto especifico.

    public Inventario buscarPorProductoHoy(String idProducto) {
        Document doc = coleccion.find(
                Filters.and(
                        Filters.eq("idProducto", idProducto),
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        ).first();
        return doc != null ? documentToInventario(doc) : null;
    }

    //  UPDATE Descuenta unidades del stock disponible al registrar una venta.

    public void descontarStock(String idProducto, int cantidad) {
        coleccion.updateOne(
                Filters.and(
                        Filters.eq("idProducto", idProducto),
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                ),
                // $inc con valor negativo descuenta el stock disponible
                Updates.inc("stockDisponible", -cantidad)
        );
    }

    //  DELETE Elimina un registro de inventario por su id.

    public void eliminarPorId(String id) {
        coleccion.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    //Elimina todos los registros de inventario del dia actual.
     //Permite reiniciar la apertura del dia si se registro mal.
    public void limpiarStockHoy() {
        coleccion.deleteMany(
                Filters.and(
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        );
    }

    //  Helpers de rango de fecha

    private Date inicioDeHoy() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE,      0);
        cal.set(Calendar.SECOND,      0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }

    private Date finDeHoy() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE,      59);
        cal.set(Calendar.SECOND,      59);
        cal.set(Calendar.MILLISECOND, 999);
        return cal.getTime();
    }



    private Inventario documentToInventario(Document doc) {
        Inventario inv = new Inventario();
        inv.setId(doc.getObjectId("_id").toString());
        inv.setIdProducto(doc.getString("idProducto"));
        inv.setNombreProducto(doc.getString("nombreProducto"));
        inv.setStockInicial(doc.getInteger("stockInicial", 0));
        inv.setStockDisponible(doc.getInteger("stockDisponible", 0));
        inv.setFecha(doc.getDate("fecha"));
        return inv;
    }
}