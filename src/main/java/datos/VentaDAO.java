package datos;

import com.mongodb.client.ClientSession;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelos.DetalleVenta;
import modelos.Venta;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;


public class VentaDAO {

    private final MongoCollection<Document> coleccion;

    public VentaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("ventas");
    }

    // ── CREATE  Inserta una venta dentro de una sesion de transaccion MongoDB.
    public void insertarEnSesion(ClientSession sesion, Venta v) {
        coleccion.insertOne(sesion, construirDocumento(v));
    }

    // Insercion simple sin transaccion.
    public void insertar(Venta v) {
        coleccion.insertOne(construirDocumento(v));
    }

    //  READ  Suma el total de ventas del dia actual.
    public double sumarVentasHoy() {
        double total = 0;
        for (Document doc : coleccion.find(
                Filters.and(
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        )) {
            Number monto = (Number) doc.get("totalVenta");
            if (monto != null) total += monto.doubleValue();
        }
        return total;
    }

    //Pipeline de agregacion para el reporte semanal de productos mas vendidos.
    public List<Document> obtenerTamalMasVendidoSemanal() {
        List<Document> resultado = new ArrayList<>();

        coleccion.aggregate(Arrays.asList(

                // paso 1: cada linea del array detalles se convierte en una fila
                new Document("$unwind", "$detalles"),

                // paso 2: agrupar por producto y acumular cantidad total vendida
                new Document("$group", new Document("_id", "$detalles.idProducto")
                        .append("totalVendido", new Document("$sum", "$detalles.cantidad"))
                ),

                // paso 3: los mas vendidos primero
                new Document("$sort", new Document("totalVendido", -1)),

                // paso 4: $convert transforma el idProducto de ObjectId a String
                // onError:null evita que el pipeline aborte si el valor no es valido
                new Document("$addFields", new Document("oidProducto",
                        new Document("$convert", new Document()
                                .append("input",   "$_id")
                                .append("to",      "objectId")
                                .append("onError", null)
                                .append("onNull",  null)
                        )
                )),

                // paso 5: join con productos usando el ObjectId convertido
                new Document("$lookup", new Document()
                        .append("from",        "productos")
                        .append("localField",  "oidProducto")
                        .append("foreignField","_id")
                        .append("as",          "info")
                ),

                // paso 6: preserveNullAndEmptyArrays evita perder filas sin match
                new Document("$unwind", new Document("path", "$info")
                        .append("preserveNullAndEmptyArrays", true)
                ),

                // paso 7: solo los campos que usa el JSP de reportes
                new Document("$project", new Document()
                        .append("_id",           1)
                        .append("totalVendido",  1)
                        .append("nombreProducto", new Document("$ifNull",
                                Arrays.asList("$info.nombre", "Sin nombre")
                        ))
                        .append("categoria", new Document("$ifNull",
                                Arrays.asList("$info.categoria", "Sin categoria")
                        ))
                )

        )).into(resultado);

        return resultado;
    }

    // ── UPDATE  Actualiza las notas de una venta existente.
    public void actualizarNotas(String id, String notas) {
        coleccion.updateOne(
                Filters.eq("_id", new ObjectId(id)),
                Updates.set("notas", notas)
        );
    }

    //  DELETE  Elimina una venta por su identificador.
    public void eliminar(String id) {
        coleccion.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    // Construccion de documento
    private Document construirDocumento(Venta v) {
        List<Document> detalles = new ArrayList<>();
        for (DetalleVenta d : v.getDetalles()) {
            detalles.add(new Document("idProducto", new ObjectId(d.getIdProducto()))
                    .append("cantidad",       d.getCantidad())
                    .append("precioUnitario", d.getPrecioUnitario()));
        }
        return new Document("fecha",       v.getFecha())
                .append("totalVenta", v.getTotalVenta())
                .append("detalles",   detalles);
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
}