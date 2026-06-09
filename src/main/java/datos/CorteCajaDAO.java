package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import modelos.CorteCaja;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;


public class CorteCajaDAO {

    private final MongoCollection<Document> coleccion;

    public CorteCajaDAO() {
        MongoDatabase db = Conexion.obtenerDB();
        this.coleccion = db.getCollection("cortes");
    }

    // CREATE Inserta un nuevo corte de caja en la BD.

    public void insertar(CorteCaja c) {
        Document doc = new Document("fecha",            c.getFecha())
                .append("efectivoInicial",  c.getEfectivoInicial())
                .append("efectivoEsperado", c.getEfectivoEsperado())
                .append("efectivoReal",     c.getEfectivoReal())
                .append("notas",            c.getNotas());
        coleccion.insertOne(doc);
    }

    // READ  Devuelve todos los cortes registrados, ordenados del mas reciente.

    public List<CorteCaja> listarTodos() {
        List<CorteCaja> lista = new ArrayList<>();
        // ordena por fecha descendente para mostrar el mas reciente primero
        for (Document doc : coleccion.find().sort(new Document("fecha", -1))) {
            lista.add(documentToCorteCaja(doc));
        }
        return lista;
    }


     //Busca un corte por su identificador unico de MongoDB.
    public CorteCaja buscarPorId(String id) {
        Document doc = coleccion.find(
                Filters.eq("_id", new ObjectId(id))
        ).first();
        return doc != null ? documentToCorteCaja(doc) : null;
    }

    // UPDATE  Actualiza las notas y el efectivo real de un corte existente.

    public void actualizar(String id, CorteCaja corte) {
        coleccion.updateOne(
                Filters.eq("_id", new ObjectId(id)),
                Updates.combine(
                        Updates.set("efectivoReal",     corte.getEfectivoReal()),
                        Updates.set("efectivoEsperado", corte.getEfectivoEsperado()),
                        Updates.set("notas",            corte.getNotas())
                )
        );
    }

    //  DELETE  Elimina un corte de caja por su id.
    public void eliminar(String id) {
        coleccion.deleteOne(Filters.eq("_id", new ObjectId(id)));
    }

    //  Convierte un Document de MongoDB en un objeto CorteCaja.
    private CorteCaja documentToCorteCaja(Document doc) {
        CorteCaja c = new CorteCaja();
        c.setId(doc.getObjectId("_id").toString());
        c.setFecha(doc.getDate("fecha"));

        // cast seguro: MongoDB puede guardar numeros como Integer o Double
        Number inicial  = (Number) doc.get("efectivoInicial");
        Number esperado = (Number) doc.get("efectivoEsperado");
        Number real     = (Number) doc.get("efectivoReal");

        c.setEfectivoInicial(  inicial  != null ? inicial.doubleValue()  : 0.0);
        c.setEfectivoEsperado( esperado != null ? esperado.doubleValue() : 0.0);
        c.setEfectivoReal(     real     != null ? real.doubleValue()     : 0.0);
        c.setNotas(doc.getString("notas"));
        return c;
    }
}