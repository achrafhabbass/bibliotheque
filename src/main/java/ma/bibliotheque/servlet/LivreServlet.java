package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.*;
import ma.bibliotheque.entities.Livre;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/livres")
public class LivreServlet extends HttpServlet {

    private final LivreDao    livreDao    = new LivreDao();
    private final AuteurDao   auteurDao   = new AuteurDao();
    private final CategorieDao catDao     = new CategorieDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new" -> {
                    req.setAttribute("auteurs", auteurDao.findAll());
                    req.setAttribute("categories", catDao.findAll());
                    req.getRequestDispatcher("/WEB-INF/views/livres.jsp").forward(req, resp);
                }
                case "edit" -> {
                    Livre l = livreDao.findByIdWithRelations(Long.parseLong(req.getParameter("id")));
                    req.setAttribute("livreEdit", l);
                    req.setAttribute("auteurs", auteurDao.findAll());
                    req.setAttribute("categories", catDao.findAll());
                    req.getRequestDispatcher("/WEB-INF/views/livres.jsp").forward(req, resp);
                }
                default -> {
                    String q = req.getParameter("q");
                    List<Livre> list = (q != null && !q.isBlank())
                            ? livreDao.search(q)
                            : livreDao.findAllWithRelations();
                    req.setAttribute("livres", list);
                    req.setAttribute("q", q);
                    req.getRequestDispatcher("/WEB-INF/views/livres.jsp").forward(req, resp);
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
                livreDao.delete(Long.parseLong(req.getParameter("id")));
                req.getSession().setAttribute("succes", "Livre supprimé.");
            } else {
                String idParam = req.getParameter("id");
                Livre livre = (idParam != null && !idParam.isBlank())
                        ? livreDao.findByIdWithRelations(Long.parseLong(idParam))
                        : new Livre();

                livre.setTitre(req.getParameter("titre").trim());
                String isbn = req.getParameter("isbn");
                livre.setIsbn((isbn == null || isbn.isBlank()) ? null : isbn.trim());
                livre.setTarifJournalier(new BigDecimal(req.getParameter("tarifJournalier")));

                String[] auteurIds = req.getParameterValues("auteurIds");
                String[] catIds    = req.getParameterValues("categorieIds");

                List<Long> aIds = auteurIds == null ? Collections.emptyList()
                        : Arrays.stream(auteurIds).map(Long::parseLong).toList();
                List<Long> cIds = catIds == null ? Collections.emptyList()
                        : Arrays.stream(catIds).map(Long::parseLong).toList();

                if (aIds.isEmpty()) {
                    req.getSession().setAttribute("erreur", "Un livre doit avoir au moins un auteur.");
                    resp.sendRedirect(req.getContextPath() + "/livres");
                    return;
                }
                if (cIds.isEmpty()) {
                    req.getSession().setAttribute("erreur", "Un livre doit appartenir à au moins une catégorie.");
                    resp.sendRedirect(req.getContextPath() + "/livres");
                    return;
                }

                livreDao.saveWithRelations(livre, aIds, cIds);
                req.getSession().setAttribute("succes", "Livre enregistré.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/livres");
    }
}
