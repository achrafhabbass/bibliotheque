package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.*;
import ma.bibliotheque.entities.Emprunt;
import java.io.IOException;
import java.util.List;

@WebServlet("/emprunts")
public class EmpruntServlet extends HttpServlet {

    private final EmpruntDao  empruntDao = new EmpruntDao();
    private final ClientDao   clientDao  = new ClientDao();
    private final LivreDao    livreDao   = new LivreDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new" -> {
                    req.setAttribute("clients", clientDao.findAll());
                    req.setAttribute("livres",  livreDao.findDisponibles());
                    req.getRequestDispatcher("/WEB-INF/views/emprunts.jsp").forward(req, resp);
                }
                case "retour" -> {
                    Emprunt e = empruntDao.findByIdWithRelations(Long.parseLong(req.getParameter("id")));
                    req.setAttribute("empruntRetour", e);
                    req.getRequestDispatcher("/WEB-INF/views/emprunts.jsp").forward(req, resp);
                }
                default -> {
                    String q      = req.getParameter("q");
                    String statut = req.getParameter("statut");
                    List<Emprunt> list = ((q != null && !q.isBlank()) || (statut != null && !statut.isBlank()))
                            ? empruntDao.search(q, statut)
                            : empruntDao.findAllWithRelations();
                    req.setAttribute("emprunts", list);
                    req.setAttribute("q", q);
                    req.setAttribute("statut", statut);
                    req.getRequestDispatcher("/WEB-INF/views/emprunts.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("retour".equals(action)) {
                empruntDao.retournerLivre(Long.parseLong(req.getParameter("empruntId")));
                req.getSession().setAttribute("succes", "Livre retourné avec succès.");
            } else if ("emprunt".equals(action)) {
                Long clientId = Long.parseLong(req.getParameter("clientId"));
                Long livreId  = Long.parseLong(req.getParameter("livreId"));
                int  duree    = Integer.parseInt(req.getParameter("dureeJours"));

                if (empruntDao.hasActiveEmprunt(clientId, livreId)) {
                    req.getSession().setAttribute("erreur", "Ce client a déjà un emprunt actif pour ce livre.");
                } else {
                    empruntDao.creerEmprunt(clientId, livreId, duree);
                    req.getSession().setAttribute("succes", "Emprunt créé avec succès.");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/emprunts");
    }
}
