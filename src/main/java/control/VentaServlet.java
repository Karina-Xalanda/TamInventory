package control;

import datos.VentaDAO;
import modelos.DetalleVenta;
import modelos.Venta;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/venta")
public class VentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // obtener datos del formulario
            int cantidad = Integer.parseInt(req.getParameter("cantidadTamales"));
            double precio = Double.parseDouble(req.getParameter("precioUnitario"));
            String idProducto = req.getParameter("idProducto");

            // crear el detalle
            DetalleVenta detalle = new DetalleVenta(cantidad, precio, idProducto); //

            // crear la venta principal
            Venta venta = new Venta(); //
            venta.agregarDetalle(detalle);
            venta.calcularTotal();

            VentaDAO dao = new VentaDAO();
            dao.insertar(venta); //

            // 5. redirige mensaje de exito
            resp.sendRedirect(req.getContextPath() + "/vistas/ventas.jsp?exito=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/vistas/ventas.jsp?error=1");
        }
    }
}