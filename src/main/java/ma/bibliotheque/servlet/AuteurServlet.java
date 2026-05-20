package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.AuteurDao;
import ma.bibliotheque.entities.Auteur;
import java.io.IOException;
import java.util.List;

@WebServlet("/auteurs")
public class AuteurServlet extends HttpServlet {

    private final AuteurDao dao = new AuteurDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            if ("edit".equals(action)) {
                req.setAttribute("auteurEdit", dao.findById(Long.parseLong(req.getParameter("id"))));
            } else {
                String q = req.getParameter("q");
                List<Auteur> list = (q != null && !q.isBlank()) ? dao.search(q) : dao.findAll();
                req.setAttribute("auteurs", list);
                req.setAttribute("q", q);
            }
            req.getRequestDispatcher("/WEB-INF/views/auteurs.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                dao.delete(Long.parseLong(req.getParameter("id")));
                req.getSession().setAttribute("succes", "Auteur supprimé.");
            } else {
                String idParam = req.getParameter("id");
                Auteur a = (idParam != null && !idParam.isBlank())
                        ? dao.findById(Long.parseLong(idParam)) : new Auteur();
                a.setNom(req.getParameter("nom").trim());
                a.setPrenom(req.getParameter("prenom").trim());
                if (a.getId() == null) dao.save(a); else dao.update(a);
                req.getSession().setAttribute("succes", "Auteur enregistré.");
            }
        } catch (Exception e) { req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage()); }
        resp.sendRedirect(req.getContextPath() + "/auteurs");
    }
}
