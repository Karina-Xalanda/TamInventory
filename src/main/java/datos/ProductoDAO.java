package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelos.Producto;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    private final MongoCollection<Document> coleccion;

    public ProductoDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("productos");
    }

    // CREATE
    public void insertar(Producto p) {
        Document doc = new Document("nombre",      p.getNombre())
                .append("descripcion", p.getDescripcion())
                .append("categoria",   p.getCategoria())
                .append("precioVenta", p.getPrecioVenta())
                .append("imagenUrl",   p.getImagenUrl());
        coleccion.insertOne(doc);
    }

    // READ - lista todos los productos del catalogo
    public List<Producto> listarTodos() {
        List<Producto> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            lista.add(documentToProducto(doc));
        }
        return lista;
    }

    // READ - busca un producto por su _id
    public Producto buscarPorId(String id) {
        Document doc = coleccion.find(
                Filters.eq("_id", new ObjectId(id))
        ).first();
        return doc != null ? documentToProducto(doc) : null;
    }

    // UPDATE
    public void actualizar(Producto p) {
        coleccion.updateOne(
                Filters.eq("_id", new ObjectId(p.getId())),
                Updates.combine(
                        Updates.set("nombre",      p.getNombre()),
                        Updates.set("descripcion", p.getDescripcion()),
                        Updates.set("categoria",   p.getCategoria()),
                        Updates.set("precioVenta", p.getPrecioVenta()),
                        Updates.set("imagenUrl",   p.getImagenUrl())
                )
        );
    }

    // DELETE
    public void eliminar(String id) {
        coleccion.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    // convierte Document de MongoDB a objeto Producto
    private Producto documentToProducto(Document doc) {
        Producto p = new Producto();
        p.setId(doc.getObjectId("_id").toString());
        p.setNombre(doc.getString("nombre"));
        p.setDescripcion(doc.getString("descripcion"));
        p.setCategoria(doc.getString("categoria"));
        p.setImagenUrl(doc.getString("imagenUrl"));

        // cast seguro: MongoDB puede guardar el numero como Integer o Double
        Number precio = (Number) doc.get("precioVenta");
        p.setPrecioVenta(precio != null ? precio.doubleValue() : 0.0);

        return p;
    }
}