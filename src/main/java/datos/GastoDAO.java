package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import modelos.Gasto;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class GastoDAO {

    private MongoCollection<Document> coleccion;

    public GastoDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("gastos");
    }

    public void insertar(Gasto g) {
        Document doc = new Document("fecha", g.getFecha())
                .append("tipo",        g.getTipo())
                .append("descripcion", g.getDescripcion())
                .append("monto",       g.getMonto());
        coleccion.insertOne(doc);
    }

    // devuelve todos los gastos sin filtro
    public List<Gasto> listarTodos() {
        List<Gasto> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            lista.add(documentToGasto(doc));
        }
        return lista;
    }

    // devuelve solo los gastos registrados hoy
    public List<Gasto> listarHoy() {
        List<Gasto> lista = new ArrayList<>();
        for (Document doc : coleccion.find(
                Filters.and(
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        )) {
            lista.add(documentToGasto(doc));
        }
        return lista;
    }

    // suma unicamente los gastos del dia actual
    public double sumarGastosHoy() {
        double total = 0;
        for (Gasto g : listarHoy()) total += g.getMonto();
        return total;
    }

    // helpers de rango de fecha
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

    private Gasto documentToGasto(Document doc) {
        Gasto g = new Gasto();
        g.setId(doc.getObjectId("_id").toString());
        g.setFecha(doc.getDate("fecha"));
        g.setTipo(doc.getString("tipo"));
        g.setDescripcion(doc.getString("descripcion"));
        g.setMonto(((Number) doc.getOrDefault("monto", 0.0)).doubleValue());
        return g;
    }
}