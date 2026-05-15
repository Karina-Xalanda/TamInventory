package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import modelos.CorteCaja;
import org.bson.Document;
import java.util.ArrayList;
import java.util.List;

public class CorteCajaDAO {

    private MongoCollection<Document> coleccion;

    public CorteCajaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("cortes");
    }

    public void insertar(CorteCaja c) {
        Document doc = new Document("fecha", c.getFecha())
                .append("efectivoInicial", c.getEfectivoInicial())
                .append("efectivoEsperado", c.getEfectivoEsperado())
                .append("efectivoReal", c.getEfectivoReal())
                .append("notas", c.getNotas());
        coleccion.insertOne(doc);
    }

    public List<CorteCaja> listarTodos() {
        List<CorteCaja> lista = new ArrayList<>();
        for (Document doc : coleccion.find()) {
            CorteCaja c = new CorteCaja();
            c.setId(doc.getObjectId("_id").toString());
            c.setFecha(doc.getDate("fecha"));
            c.setEfectivoInicial(doc.getDouble("efectivoInicial"));
            c.setEfectivoEsperado(doc.getDouble("efectivoEsperado"));
            c.setEfectivoReal(doc.getDouble("efectivoReal"));
            c.setNotas(doc.getString("notas"));
            lista.add(c);
        }
        return lista;
    }
}