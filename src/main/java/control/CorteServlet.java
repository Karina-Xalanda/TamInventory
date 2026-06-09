package control;

import datos.CorteCajaDAO;
import datos.GastoDAO;
import datos.MermaDAO;
import datos.VentaDAO;
import modelos.CorteCaja;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/corte")
public class CorteServlet extends HttpServlet {

    //  calcula ventas, gastos y mermas del dia automaticamente
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        double ventasHoy = new VentaDAO().sumarVentasHoy();
        double gastosHoy = new GastoDAO().sumarGastosHoy();
        double mermasHoy = new MermaDAO().sumarMermasHoy();

        req.setAttribute("ventasHoy", ventasHoy);
        req.setAttribute("gastosHoy", gastosHoy);
        req.setAttribute("mermasHoy", mermasHoy);

        req.getRequestDispatcher("/vistas/corte.jsp").forward(req, resp);
    }

    //  recibe efectivo inicial y real, calcula y guarda el corte
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            double efectivoInicial = Double.parseDouble(req.getParameter("efectivoInicial"));
            double efectivoReal    = Double.parseDouble(req.getParameter("efectivoReal"));

            // se reconsulta la BD, no se confia en valores del formulario
            double ventasHoy = new VentaDAO().sumarVentasHoy();
            double gastosHoy = new GastoDAO().sumarGastosHoy();
            double mermasHoy = new MermaDAO().sumarMermasHoy();

            // formula completa: inicial + ventas - gastos - mermas
            CorteCaja corte = new CorteCaja(efectivoInicial);
            corte.setEfectivoReal(efectivoReal);
            corte.calcularEfectivoEsperado(ventasHoy, gastosHoy + mermasHoy);

            double diferencia = corte.validarDiferencia();
            corte.setNotas(diferencia == 0
                    ? "Corte perfecto"
                    : (diferencia > 0
                       ? "Sobrante: $" + String.format("%.2f", diferencia)
                       : "Faltante: $" + String.format("%.2f", Math.abs(diferencia))));

            new CorteCajaDAO().insertar(corte);

            req.setAttribute("corte",      corte);
            req.setAttribute("diferencia", diferencia);
            req.setAttribute("ventasHoy",  ventasHoy);
            req.setAttribute("gastosHoy",  gastosHoy);
            req.setAttribute("mermasHoy",  mermasHoy);

            req.getRequestDispatcher("/vistas/corte.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/corte?error=1");
        }
    }
}