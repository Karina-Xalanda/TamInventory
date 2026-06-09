package control;

import com.mongodb.client.ClientSession;
import datos.Conexion;
import datos.InventarioDAO;
import datos.ProductoDAO;
import datos.VentaDAO;
import modelos.DetalleVenta;
import modelos.Inventario;
import modelos.Producto;
import modelos.Venta;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/venta")
public class VentaServlet extends HttpServlet {

    // carga productos y stock del dia, los manda al JSP
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // redirige si no hay sesion activa
        if (req.getSession().getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        ProductoDAO   productoDAO   = new ProductoDAO();
        InventarioDAO inventarioDAO = new InventarioDAO();

        List<Producto>   productos      = productoDAO.listarTodos();
        List<Inventario> stockHoy       = inventarioDAO.listarStockHoy();
        boolean          stockRegistrado = !stockHoy.isEmpty();

        req.setAttribute("productos",        productos);
        req.setAttribute("stockHoy",         stockHoy);
        req.setAttribute("stockRegistrado",  stockRegistrado);

        req.getRequestDispatcher("/vistas/ventas.jsp").forward(req, resp);
    }

    // maneja dos acciones segun el parametro "accion"
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");

        // accion 1: el empleado registra cuantos tamales hizo hoy
        if ("abrirDia".equals(accion)) {
            registrarApertura(req);
            resp.sendRedirect(req.getContextPath() + "/venta?apertura=ok");
            return;
        }

        // accion 2: registrar una venta con transaccion
        try {
            // ids, cantidades y precios vienen como arreglos paralelos del formulario
            String[] ids       = req.getParameterValues("idProducto[]");
            String[] cantidades = req.getParameterValues("cantidad[]");
            String[] precios   = req.getParameterValues("precio[]");

            if (ids == null || ids.length == 0) {
                resp.sendRedirect(req.getContextPath() + "/venta?error=vacio");
                return;
            }

            // construir objeto Venta con todos sus detalles
            Venta venta = new Venta();
            for (int i = 0; i < ids.length; i++) {
                DetalleVenta det = new DetalleVenta(
                        Integer.parseInt(cantidades[i]),
                        Double.parseDouble(precios[i]),
                        ids[i]
                );
                venta.agregarDetalle(det);
            }
            venta.calcularTotal();

            // transaccion: guarda la venta y descuenta inventario juntos
            VentaDAO      ventaDAO      = new VentaDAO();
            InventarioDAO inventarioDAO = new InventarioDAO();

            try (ClientSession sesion = Conexion.abrirSesion()) {
                sesion.startTransaction();
                try {
                    ventaDAO.insertarEnSesion(sesion, venta);
                    for (DetalleVenta det : venta.getDetalles()) {
                        inventarioDAO.descontarStock(det.getIdProducto(), det.getCantidad());
                    }
                    sesion.commitTransaction();
                } catch (Exception e) {
                    sesion.abortTransaction();
                    throw e;
                }
            }

            resp.sendRedirect(req.getContextPath() + "/venta?exito=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/venta?error=1");
        }
    }

    // registra el stock inicial de cada producto para el dia
    private void registrarApertura(HttpServletRequest req) {
        ProductoDAO   productoDAO   = new ProductoDAO();
        InventarioDAO inventarioDAO = new InventarioDAO();

        for (Producto p : productoDAO.listarTodos()) {
            String valor = req.getParameter("stock_" + p.getId());
            if (valor != null && !valor.isEmpty()) {
                int cantidad = Integer.parseInt(valor);
                inventarioDAO.registrarStockDia(
                        new Inventario(p.getId(), p.getNombre(), cantidad)
                );
            }
        }
    }
}