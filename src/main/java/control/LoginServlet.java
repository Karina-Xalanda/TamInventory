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

    //muestra el formulario, si ya hay sesion activa manda al menu
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession sesion = req.getSession(false);
        if (sesion != null && sesion.getAttribute("usuario") != null) {
            // ya hay sesion, ir al menu
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }
        req.getRequestDispatcher("/vistas/login.jsp").forward(req, resp);
    }

    //  valida credenciales y redirige al MENU principal
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String nombre   = req.getParameter("nombre");
        String password = req.getParameter("password");

        if (nombre == null || nombre.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("errorMsg", "Completa todos los campos.");
            req.getRequestDispatcher("/vistas/login.jsp").forward(req, resp);
            return;
        }

        UsuarioDAO dao = new UsuarioDAO();
        Usuario u = dao.buscarPorNombre(nombre.trim());

        if (u != null && u.getPassword().equals(password)) {
            HttpSession sesion = req.getSession(true);
            sesion.setAttribute("usuario", u.getNombre());
            sesion.setMaxInactiveInterval(60 * 60);
            // redirige al MENU
            resp.sendRedirect(req.getContextPath() + "/menu");
        } else {
            req.setAttribute("errorMsg", "Usuario o contrasena incorrectos.");
            req.getRequestDispatcher("/vistas/login.jsp").forward(req, resp);
        }
    }
}