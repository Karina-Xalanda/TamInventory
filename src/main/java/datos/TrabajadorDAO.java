package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Trabajador;
import org.bson.Document;
import java.util.ArrayList;
import java.util.List;

public class TrabajadorDAO {

    private MongoCollection<Document> coleccion;

    public TrabajadorDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("trabajadores");
    }

    public List<Trabajador> listarTodos() {
        List<Trabajador> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            Trabajador t = new Trabajador();
            t.setId(doc.getObjectId("_id").toString());
            t.setNombre(doc.getString("nombre"));
            t.setTelefono(doc.getString("telefono"));
            lista.add(t);
        }
        return lista;
    }

    public void insertar(Trabajador t) {
        Document doc = new Document("nombre", t.getNombre())
                .append("telefono", t.getTelefono());
        coleccion.insertOne(doc);
    }
}