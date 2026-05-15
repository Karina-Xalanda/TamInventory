package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.DetalleVenta;
import modelos.Venta;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {

    private MongoCollection<Document> coleccion;

    public VentaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("ventas");
    }

    public void insertar(Venta v) {
        List<Document> detalles = new ArrayList<>();
        for (DetalleVenta d : v.getDetalles()) {
            detalles.add(new Document("cantidad", d.getCantidad())
                    .append("precioUnitario", d.getPrecioUnitario())
                    .append("idProducto", d.getIdProducto()));
        }
        Document doc = new Document("fecha", v.getFecha())
                .append("totalVenta", v.getTotalVenta())
                .append("detalles", detalles);
        coleccion.insertOne(doc);
    }

    public double sumarVentasHoy() {
        double total = 0;
        for (Document doc : coleccion.find()) {
            total += doc.getDouble("totalVenta");
        }
        return total;
    }
}