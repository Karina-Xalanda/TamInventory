package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelos.Merma;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class MermaDAO {

    private final MongoCollection<Document> coleccion;

    public MermaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("mermas");
    }

    // CREATE
    public void insertar(Merma m) {
        Document doc = new Document("fecha",         m.getFecha())
                .append("tipo",          m.getTipo())
                .append("descripcion",   m.getDescripcion())
                .append("valorMerma",    m.getValorMerma())
                .append("cantidadMerma", m.getCantidadMerma())
                .append("idProducto",    m.getIdProducto());
        coleccion.insertOne(doc);
    }

    // READ: todas
    public List<Merma> listarTodos() {
        List<Merma> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            lista.add(documentToMerma(doc));
        }
        return lista;
    }

    // READ: solo las de hoy
    public List<Merma> listarHoy() {
        List<Merma> lista = new ArrayList<>();
        for (Document doc : coleccion.find(
                Filters.and(
                        Filters.gte("fecha", inicioDeHoy()),
                        Filters.lt("fecha",  finDeHoy())
                )
        )) {
            lista.add(documentToMerma(doc));
        }
        return lista;
    }

    // suma el valor total de mermas del dia para el corte de caja
    public double sumarMermasHoy() {
        double total = 0;
        for (Merma m : listarHoy()) total += m.getValorMerma();
        return total;
    }

    //  UPDATE
    public void actualizar(Merma m) {
        coleccion.updateOne(
                Filters.eq("_id", new ObjectId(m.getId())),
                Updates.combine(
                        Updates.set("tipo",          m.getTipo()),
                        Updates.set("descripcion",   m.getDescripcion()),
                        Updates.set("valorMerma",    m.getValorMerma()),
                        Updates.set("cantidadMerma", m.getCantidadMerma()),
                        Updates.set("idProducto",    m.getIdProducto())
                )
        );
    }

    //  DELETE
    public void eliminar(String id) {
        coleccion.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    // ── Helpers ───────────────────────────────
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

    private Merma documentToMerma(Document doc) {
        Merma m = new Merma();
        m.setId(doc.getObjectId("_id").toString());
        m.setFecha(doc.getDate("fecha"));
        m.setTipo(doc.getString("tipo"));
        m.setDescripcion(doc.getString("descripcion"));
        m.setIdProducto(doc.getString("idProducto"));

        Number valor    = (Number) doc.get("valorMerma");
        Number cantidad = (Number) doc.get("cantidadMerma");
        m.setValorMerma(   valor    != null ? valor.doubleValue()    : 0.0);
        m.setCantidadMerma(cantidad != null ? cantidad.doubleValue() : 0.0);

        return m;
    }
}