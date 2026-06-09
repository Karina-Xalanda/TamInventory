package control;

import datos.InventarioDAO;
import modelos.Inventario;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


//Endpoint JSON que devuelve el stock disponible de un producto hoy.

@WebServlet("/stockDisponible")
public class StockDisponibleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (req.getSession(false) == null
                || req.getSession(false).getAttribute("usuario") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idProducto = req.getParameter("idProducto");
        int stock = 0;

        if (idProducto != null && !idProducto.isEmpty()) {
            try {
                Inventario inv = new InventarioDAO().buscarPorProductoHoy(idProducto);
                if (inv != null) stock = inv.getStockDisponible();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // respuesta en JSON plano
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"stockDisponible\":" + stock + "}");
    }
}