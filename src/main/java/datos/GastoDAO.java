package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Gasto;
import org.bson.Document;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;

public class GastoDAO {

    private MongoCollection<Document> coleccion;

    public GastoDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("gastos");
    }

    public void insertar(Gasto g) {
        Document doc = new Document("fecha", g.getFecha())
                .append("tipo", g.getTipo())
                .append("descripcion", g.getDescripcion())
                .append("monto", g.getMonto());
        coleccion.insertOne(doc);
    }

    public List<Gasto> listarTodos() {
        List<Gasto> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            Gasto g = new Gasto();
            g.setId(doc.getObjectId("_id").toString());
            g.setFecha(doc.getDate("fecha"));
            g.setTipo(doc.getString("tipo"));
            g.setDescripcion(doc.getString("descripcion"));
            g.setMonto(doc.getDouble("monto"));
            lista.add(g);
        }
        return lista;
    }

    public double sumarGastosHoy() {
        double total = 0;
        for (Gasto g : listarTodos()) total += g.getMonto();
        return total;
    }
}