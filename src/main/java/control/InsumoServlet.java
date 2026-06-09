package control;

import datos.InsumoDAO;
import modelos.Insumo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@WebServlet("/insumos")
public class InsumoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // verificar sesion activa antes de mostrar el modulo
        if (req.getSession(false) == null
                || req.getSession(false).getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // consultar todos los insumos en MongoDB y mandarlos al JSP
        InsumoDAO dao = new InsumoDAO();
        List<Insumo> listaInsumos = dao.listarTodos();
        req.setAttribute("insumos", listaInsumos);

        req.getRequestDispatcher("/vistas/insumos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // verificar sesion activa
        if (req.getSession(false) == null
                || req.getSession(false).getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String accion = req.getParameter("accion");
        InsumoDAO dao = new InsumoDAO();

        try {
            if ("agregar".equals(accion)) {
                // crear nuevo insumo con nombre y cantidad inicial
                String nombre   = req.getParameter("nombre");
                double cantidad = Double.parseDouble(req.getParameter("cantidad"));
                dao.insertar(new Insumo(nombre, cantidad));

            } else if ("actualizar".equals(accion)) {
                // actualizar solo la cantidad de un insumo existente
                String id           = req.getParameter("id");
                double nuevaCantidad = Double.parseDouble(req.getParameter("nuevaCantidad"));
                dao.actualizarCantidad(id, nuevaCantidad);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // redirige al GET para evitar reenvio del formulario al recargar
        resp.sendRedirect(req.getContextPath() + "/insumos");
    }
}