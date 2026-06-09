package datos;

import com.mongodb.client.ClientSession;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;


public class Conexion {

    // instancia unica del cliente MongoDB
    private static MongoClient   cliente;
    private static MongoDatabase db;


    public static MongoDatabase obtenerDB() {
        if (db == null) {
            try {
                // lee las credenciales de las variables de entorno
                String uri    = System.getenv("MONGO_URI");
                String nombre = System.getenv("MONGO_DB");

                cliente = MongoClients.create(uri);
                db      = cliente.getDatabase(nombre);
                System.out.println("Conectado a MongoDB Atlas: " + db.getName());

            } catch (Exception e) {
                System.err.println("Error al conectar: " + e.getMessage());
            }
        }
        return db;
    }


     //Abre una nueva sesion de cliente para operaciones transaccionales.
    public static ClientSession abrirSesion() {
        if (cliente == null) obtenerDB();
        return cliente.startSession();
    }

    //Cierra la conexion al apagar el servidor.

    public static void cerrar() {
        if (cliente != null) cliente.close();
    }
}