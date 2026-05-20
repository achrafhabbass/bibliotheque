package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.UtilisateurDao;
import ma.bibliotheque.entities.Utilisateur;
import ma.bibliotheque.util.PasswordUtil;
import java.io.IOException;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    private final UtilisateurDao dao = new UtilisateurDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new" -> {
                    req.getRequestDispatcher("/WEB-INF/views/utilisateurs.jsp").forward(req, resp);
                }
                case "edit" -> {
                    Utilisateur u = dao.findById(Long.parseLong(req.getParameter("id")));
                    req.setAttribute("utilisateurEdit", u);
                    req.getRequestDispatcher("/WEB-INF/views/utilisateurs.jsp").forward(req, resp);
                }
                default -> {
                    String q = req.getParameter("q");
                    List<Utilisateur> list = (q != null && !q.isBlank()) ? dao.search(q) : dao.findAll();
                    req.setAttribute("utilisateurs", list);
                    req.setAttribute("q", q);
                    req.getRequestDispatcher("/WEB-INF/views/utilisateurs.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Utilisateur u = dao.findById(id);
                if (u != null && u.getRole() == Utilisateur.Role.ADMIN && dao.countAdmins() <= 1) {
                    req.getSession().setAttribute("erreur", "Impossible de supprimer le seul administrateur.");
                } else {
                    dao.delete(id);
                    req.getSession().setAttribute("succes", "Utilisateur supprimé.");
                }
            } else {
                String idParam = req.getParameter("id");
                Utilisateur u = (idParam != null && !idParam.isBlank())
                        ? dao.findById(Long.parseLong(idParam))
                        : new Utilisateur();

                u.setNom(req.getParameter("nom").trim());
                u.setPrenom(req.getParameter("prenom").trim());
                u.setEmail(req.getParameter("email").trim());

                Utilisateur.Role newRole = Utilisateur.Role.valueOf(req.getParameter("role"));
                if (u.getId() != null
                        && u.getRole() == Utilisateur.Role.ADMIN
                        && newRole == Utilisateur.Role.MANAGER
                        && dao.countAdmins() <= 1) {
                    req.getSession().setAttribute("erreur",
                            "Impossible de rétrograder le seul administrateur.");
                    resp.sendRedirect(req.getContextPath() + "/utilisateurs");
                    return;
                }
                u.setRole(newRole);

                String mdp = req.getParameter("motDePasse");
                if (mdp != null && !mdp.isBlank()) u.setMotDePasse(PasswordUtil.hash(mdp));

                if (u.getId() == null) dao.save(u);
                else dao.update(u);

                req.getSession().setAttribute("succes", "Utilisateur enregistré.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/utilisateurs");
    }
}
