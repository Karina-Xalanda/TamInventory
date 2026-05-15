package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.Merma;
import org.bson.Document;
import java.util.ArrayList;
import java.util.List;

public class MermaDAO {

    private MongoCollection<Document> coleccion;

    public MermaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("mermas");
    }

    public void insertar(Merma m) {
        Document doc = new Document("fecha", m.getFecha())
                .append("tipo", m.getTipo())
                .append("descripcion", m.getDescripcion())
                .append("valorMerma", m.getValorMerma())
                .append("cantidadMerma", m.getCantidadMerma())
                .append("idProducto", m.getIdProducto());
        coleccion.insertOne(doc);
    }

    public List<Merma> listarTodos() {
        List<Merma> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            Merma m = new Merma();
            m.setId(doc.getObjectId("_id").toString());
            m.setFecha(doc.getDate("fecha"));
            m.setTipo(doc.getString("tipo"));
            m.setDescripcion(doc.getString("descripcion"));
            m.setValorMerma(doc.getDouble("valorMerma"));
            m.setCantidadMerma(doc.getDouble("cantidadMerma"));
            m.setIdProducto(doc.getString("idProducto"));
            lista.add(m);
        }
        return lista;
    }
}