package control;

import datos.GastoDAO;
import datos.InventarioDAO;
import datos.MermaDAO;
import datos.ProductoDAO;
import modelos.Gasto;
import modelos.Inventario;
import modelos.Merma;
import modelos.Producto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/egresos")
public class EgresoServlet extends HttpServlet {

    //  carga productos para el selector de mermas y manda al JSP
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        ProductoDAO productoDAO = new ProductoDAO();
        List<Producto> productos = productoDAO.listarTodos();
        req.setAttribute("productos", productos);

        GastoDAO gastoDAO = new GastoDAO();
        req.setAttribute("gastosHoy", gastoDAO.listarHoy());

        // solo muestra mermas del dia actual
        MermaDAO mermaDAO = new MermaDAO();
        req.setAttribute("mermasHoy", mermaDAO.listarHoy());

        req.getRequestDispatcher("/vistas/egresos.jsp").forward(req, resp);
    }

    // guarda gasto o merma segun tipoOperacion
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String tipoOperacion = req.getParameter("tipoOperacion");

        try {
            if ("gasto".equals(tipoOperacion)) {
                String tipo        = req.getParameter("tipo");
                String descripcion = req.getParameter("descripcion");
                double monto       = Double.parseDouble(req.getParameter("monto"));

                GastoDAO dao = new GastoDAO();
                dao.insertar(new Gasto(tipo, descripcion, monto));

            } else if ("merma".equals(tipoOperacion)) {
                String tipo        = req.getParameter("tipo");
                String descripcion = req.getParameter("descripcion");
                String idProducto  = req.getParameter("idProducto");
                double cantidad    = Double.parseDouble(req.getParameter("cantidadMerma"));

                //  verificar que el producto tenga stock registrado hoy
                // antes de permitir registrar la merma
                InventarioDAO invDAO = new InventarioDAO();
                Inventario stockHoy = invDAO.buscarPorProductoHoy(idProducto);
                int stockDisponible = (stockHoy != null) ? stockHoy.getStockDisponible() : 0;

                if (stockDisponible <= 0) {
                    // no hay stock registrado para ese producto hoy
                    resp.sendRedirect(req.getContextPath() + "/egresos?error=sinstock");
                    return;
                }

                if ((int) cantidad > stockDisponible) {
                    // la merma pedida supera lo que hay disponible
                    resp.sendRedirect(req.getContextPath() + "/egresos?error=excede");
                    return;
                }

                // usa el precio real del producto para calcular el valor de la merma
                double precioUnitario = 0.0;
                if (idProducto != null && !idProducto.isEmpty()) {
                    ProductoDAO pDao = new ProductoDAO();
                    Producto p = pDao.buscarPorId(idProducto);
                    if (p != null) precioUnitario = p.getPrecioVenta();
                }
                double valorMerma = cantidad * precioUnitario;

                MermaDAO dao = new MermaDAO();
                dao.insertar(new Merma(tipo, descripcion, valorMerma, cantidad, idProducto));
            }

            resp.sendRedirect(req.getContextPath() + "/egresos?exito=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/egresos?error=1");
        }
    }
}