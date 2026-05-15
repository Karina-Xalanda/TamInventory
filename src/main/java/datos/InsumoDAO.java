package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Insumo;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;

public class InsumoDAO {

    private MongoCollection<Document> coleccion;

    public InsumoDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("insumos");
    }

    public List<Insumo> listarTodos() {
        List<Insumo> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            Insumo i = new Insumo();
            i.setId(doc.getObjectId("_id").toString());
            i.setNombre(doc.getString("nombre"));
            i.setCantidad(doc.getDouble("cantidad"));
            lista.add(i);
        }
        return lista;
    }

    public void insertar(Insumo i) {
        Document doc = new Document("nombre", i.getNombre())
                .append("cantidad", i.getCantidad());
        coleccion.insertOne(doc);
    }

    public void actualizarCantidad(String id, double nuevaCantidad) {
        coleccion.updateOne(
                new Document("_id", new ObjectId(id)),
                new Document("$set", new Document("cantidad", nuevaCantidad))
        );
    }

    public void eliminar(String id) {
        coleccion.deleteOne(new Document("_id", new ObjectId(id)));
    }
}