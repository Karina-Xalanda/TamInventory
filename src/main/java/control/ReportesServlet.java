package control;

import datos.InsumoDAO;
import datos.VentaDAO;
import modelos.Insumo;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/reportes")
public class ReportesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            //  obtener alertas de inventario
            InsumoDAO insumoDao = new InsumoDAO();
            List<Insumo> criticos = insumoDao.obtenerInsumosCriticos();

            // obtener el producto mas vendido
            VentaDAO ventaDao = new VentaDAO();
            List<Document> topTamales = ventaDao.obtenerTamalMasVendidoSemanal();

            // enviar los datos a la vista JSP
            req.setAttribute("criticos", criticos);
            req.setAttribute("topTamales", topTamales);

            req.getRequestDispatcher("vistas/reportes.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();

            resp.sendRedirect(req.getContextPath() + "/vistas/menu.jsp?error=reporte");
        }
    }
}