package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.UtilisateurDao;
import ma.bibliotheque.entities.Utilisateur;
import ma.bibliotheque.util.PasswordUtil;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UtilisateurDao dao = new UtilisateurDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("utilisateur") != null) {
            resp.sendRedirect(req.getContextPath() + "/livres");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String mdp   = req.getParameter("motDePasse");

        Utilisateur u = dao.findByEmail(email);
        if (u != null && PasswordUtil.verify(mdp, u.getMotDePasse())) {
            HttpSession session = req.getSession(true);
            session.setAttribute("utilisateur", u);
            resp.sendRedirect(req.getContextPath() + "/livres");
        } else {
            req.setAttribute("erreur", "Email ou mot de passe incorrect.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
