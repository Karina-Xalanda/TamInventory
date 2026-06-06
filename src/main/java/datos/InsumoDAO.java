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
            Number cantidadObj = (Number) doc.get("cantidad");
            i.setCantidad(cantidadObj != null ? cantidadObj.doubleValue() : 0.0);// Lo convertimos a Double de forma segura, previniendo valores nulos
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

    public List<Insumo> obtenerInsumosCriticos() {
        List<Insumo> criticos = new ArrayList<>();
        // filtra los insumos que la cantidad en stock sea menor a 5.0
        Document filtro = new Document("cantidad", new Document("$lt", 5.0));

        for (Document doc : coleccion.find(filtro)) {
            Insumo i = new Insumo();
            i.setId(doc.getObjectId("_id").toString());
            i.setNombre(doc.getString("nombre"));

            Number cantidadObj = (Number) doc.get("cantidad");
            i.setCantidad(cantidadObj != null ? cantidadObj.doubleValue() : 0.0);

            criticos.add(i);
        }
        return criticos;
    }
}