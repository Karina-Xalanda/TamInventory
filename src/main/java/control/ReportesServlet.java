package control;

import datos.InsumoDAO;
import datos.ProductoDAO;
import datos.VentaDAO;
import modelos.Insumo;
import modelos.Producto;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportes")
public class ReportesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // verificar sesion activa
        if (req.getSession(false) == null
                || req.getSession(false).getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // insumos con menos de 5 unidades para la seccion de alertas
            List<Insumo> criticos = new InsumoDAO().obtenerInsumosCriticos();

            // pipeline de agregacion: devuelve ranking de productos vendidos
            List<Document> topTamales = new VentaDAO().obtenerTamalMasVendidoSemanal();

            ProductoDAO productoDAO = new ProductoDAO();
            List<Document> enriquecidos = new ArrayList<>();

            for (Document d : topTamales) {

                //  _id es ObjectId, usar toString() en vez de getString()
                String idStr = d.get("_id") != null ? d.get("_id").toString() : "";

                // intentar leer nombreProducto que el pipeline ya resolvio via $lookup
                String nombre    = d.getString("nombreProducto");
                String categoria = d.getString("categoria");

                // si el nombre no se resolvio en el pipeline, buscar directamente
                if ((nombre == null || nombre.equals("Sin nombre")) && !idStr.isEmpty()) {
                    try {
                        Producto p = productoDAO.buscarPorId(idStr);
                        if (p != null) {
                            nombre    = p.getNombre();
                            categoria = p.getCategoria();
                        }
                    } catch (Exception ignored) {
                        // id invalido o producto eliminado, se usa el fallback abajo
                    }
                }

                // garantizar que nombre y categoria nunca sean null en el JSP
                if (nombre    == null) nombre    = "Producto " + idStr;
                if (categoria == null) categoria = "Sin categoria";

                Document enriquecido = new Document()
                        .append("_id",            idStr)
                        .append("totalVendido",   d.get("totalVendido"))
                        .append("nombreProducto", nombre)
                        .append("categoria",      categoria);

                enriquecidos.add(enriquecido);
            }

            req.setAttribute("criticos",   criticos);
            req.setAttribute("topTamales", enriquecidos);

            req.getRequestDispatcher("/vistas/reportes.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/menu");
        }
    }
}