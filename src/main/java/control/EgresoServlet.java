package control;

import datos.GastoDAO;
import datos.MermaDAO;
import modelos.Gasto;
import modelos.Merma;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/egresos")
public class EgresoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // checar si el formulario enviado es de GASTO o de MERMA
        String tipoOperacion = req.getParameter("tipoOperacion");

        try {
            if ("gasto".equals(tipoOperacion)) {
                String tipo = req.getParameter("tipo");
                String descripcion = req.getParameter("descripcion");
                double monto = Double.parseDouble(req.getParameter("monto"));

                GastoDAO dao = new GastoDAO();
                dao.insertar(new Gasto(tipo, descripcion, monto));

            } else if ("merma".equals(tipoOperacion)) {
                String tipo = req.getParameter("tipo");
                String descripcion = req.getParameter("descripcion");
                double cantidad = Double.parseDouble(req.getParameter("cantidadMerma"));

                // Calcula el valor aproximado de perdida
                double valorMerma = cantidad * 15.0;

                MermaDAO dao = new MermaDAO();
                // Usamos TAMAL_GENERAL como ID temporal
                dao.insertar(new Merma(tipo, descripcion, valorMerma, cantidad, "TAMAL_GENERAL")); // Guarda en MongoDB
            }

            // Redirige mensaje de exito
            resp.sendRedirect(req.getContextPath() + "/vistas/egresos.jsp?exito=1");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/vistas/egresos.jsp?error=1");
        }
    }
}