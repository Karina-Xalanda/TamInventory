package datos;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class Conexion {

    private static MongoClient cliente;
    private static MongoDatabase db;

    public static MongoDatabase obtenerDB() {
        if (db == null) {
            try {
                String uri    = System.getenv("MONGO_URI");
                String nombre = System.getenv("MONGO_DB");

                cliente = MongoClients.create(uri);
                db      = cliente.getDatabase(nombre);
                System.out.println("Conectado a: " + db.getName());

            } catch (Exception e) {
                System.err.println("Error: " + e.getMessage());
            }
        }
        return db;
    }

    public static void cerrar() {
        if (cliente != null) cliente.close();
    }
}