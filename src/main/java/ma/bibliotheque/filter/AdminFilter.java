package ma.bibliotheque.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import ma.bibliotheque.entities.Utilisateur;
import java.io.IOException;

public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null || u.getRole() != Utilisateur.Role.ADMIN) {
            request.setAttribute("erreurCode", 403);
            request.setAttribute("erreurMsg", "Accès réservé à l'administrateur.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }
        chain.doFilter(req, res);
    }
}
