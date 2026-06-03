package control;

import datos.CorteCajaDAO;
import datos.GastoDAO;
import datos.VentaDAO;
import modelos.CorteCaja;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/corte")
public class CorteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Recuperar datos del formulario
        int hoy = Integer.parseInt(req.getParameter("tamalesHoy"));
        int ayer = Integer.parseInt(req.getParameter("tamalesAyer"));
        int mermas = Integer.parseInt(req.getParameter("mermas"));
        double efectivoReal = Double.parseDouble(req.getParameter("efectivoReal"));
        double inicial = Double.parseDouble(req.getParameter("efectivoInicial"));

        // Obtener totales automaticos de MongoDB
        VentaDAO vDao = new VentaDAO();
        GastoDAO gDao = new GastoDAO();
        double ventasDelDia = vDao.sumarVentasHoy();
        double gastosDelDia = gDao.sumarGastosHoy();

        // calculadora
        // (Ventas + Inicial) - Gastos = Dinero que debe haber
        CorteCaja corte = new CorteCaja(inicial);
        corte.setEfectivoReal(efectivoReal);

        double esperado = corte.calcularEfectivoEsperado(ventasDelDia, gastosDelDia); //
        double diferencia = corte.validarDiferencia(); //

        // guardar en MongoDB Atlas
        CorteCajaDAO corteDao = new CorteCajaDAO();
        corte.setNotas("Inventario procesado: " + (hoy + ayer - mermas) + " unidades vendidas.");
        corteDao.insertar(corte); //

        // enviar resultados a la vista de exito
        req.setAttribute("corte", corte);
        req.setAttribute("diferencia", diferencia);
        req.getRequestDispatcher("vistas/resultado_corte.jsp").forward(req, resp);
    }
}