package control;

import datos.UsuarioDAO;
import modelos.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nombre   = req.getParameter("nombre");
        String password = req.getParameter("password");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario u = dao.buscarPorNombre(nombre);

        if (u != null && u.getPassword().equals(password)) {
            HttpSession sesion = req.getSession();
            sesion.setAttribute("usuario", u.getNombre());
            resp.sendRedirect("vistas/menu.jsp");
        } else {
            resp.sendRedirect("vistas/login.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("vistas/login.jsp");
    }
}