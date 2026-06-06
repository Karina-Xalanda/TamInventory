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

        // consultar todos los insumos en MongoDB
        InsumoDAO dao = new InsumoDAO();
        List<Insumo> listaInsumos = dao.listarTodos();

        //  mandar la lista a la vista JSP
        req.setAttribute("insumos", listaInsumos);
        req.getRequestDispatcher("vistas/insumos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        InsumoDAO dao = new InsumoDAO();

        try {
            if ("agregar".equals(accion)) {
                String nombre = req.getParameter("nombre");
                double cantidad = Double.parseDouble(req.getParameter("cantidad"));
                dao.insertar(new Insumo(nombre, cantidad)); //

            } else if ("actualizar".equals(accion)) {
                String id = req.getParameter("id");
                double nuevaCantidad = Double.parseDouble(req.getParameter("nuevaCantidad"));
                dao.actualizarCantidad(id, nuevaCantidad); //
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // eedirige de nuevo a la lista  para ver los cambios
        resp.sendRedirect(req.getContextPath() + "/insumos");
    }
}