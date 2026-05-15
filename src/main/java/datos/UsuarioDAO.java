package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Usuario;
import org.bson.Document;

public class UsuarioDAO {

    private MongoCollection<Document> coleccion;

    public UsuarioDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("usuarios");
    }

    public Usuario buscarPorNombre(String nombre) {
        Document doc = coleccion.find(new Document("nombre", nombre)).first();
        if (doc == null) return null;

        Usuario u = new Usuario();
        u.setId(doc.getObjectId("_id").toString());
        u.setNombre(doc.getString("nombre"));
        u.setPassword(doc.getString("password"));
        return u;
    }

    public void insertar(Usuario u) {
        Document doc = new Document("nombre", u.getNombre())
                .append("password", u.getPassword());
        coleccion.insertOne(doc);
    }
}