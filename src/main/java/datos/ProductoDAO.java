package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Producto;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    private MongoCollection<Document> coleccion;

    public ProductoDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("productos");
    }

    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            Producto p = new Producto();
            p.setId(doc.getObjectId("_id").toString());
            p.setNombre(doc.getString("nombre"));
            p.setDescripcion(doc.getString("descripcion"));
            p.setCategoria(doc.getString("categoria"));
            p.setPrecioVenta(doc.getDouble("precioVenta"));
            lista.add(p);
        }
        return lista;
    }

    public Producto buscarPorId(String id) {
        Document doc = coleccion.find(new Document("_id", new ObjectId(id))).first();
        if (doc == null) return null;
        Producto p = new Producto();
        p.setId(doc.getObjectId("_id").toString());
        p.setNombre(doc.getString("nombre"));
        p.setDescripcion(doc.getString("descripcion"));
        p.setCategoria(doc.getString("categoria"));
        p.setPrecioVenta(doc.getDouble("precioVenta"));
        return p;
    }

    public void insertar(Producto p) {
        Document doc = new Document("nombre", p.getNombre())
                .append("descripcion", p.getDescripcion())
                .append("categoria", p.getCategoria())
                .append("precioVenta", p.getPrecioVenta());
        coleccion.insertOne(doc);
    }
}