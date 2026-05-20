package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.CategorieDao;
import ma.bibliotheque.entities.Categorie;
import java.io.IOException;
import java.util.List;

@WebServlet("/categories")
public class CategorieServlet extends HttpServlet {

    private final CategorieDao dao = new CategorieDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            if ("edit".equals(action)) {
                req.setAttribute("categorieEdit", dao.findById(Long.parseLong(req.getParameter("id"))));
            } else {
                String q = req.getParameter("q");
                List<Categorie> list = (q != null && !q.isBlank()) ? dao.search(q) : dao.findAll();
                req.setAttribute("categories", list);
                req.setAttribute("q", q);
            }
            req.getRequestDispatcher("/WEB-INF/views/categories.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                dao.delete(Long.parseLong(req.getParameter("id")));
                req.getSession().setAttribute("succes", "Catégorie supprimée.");
            } else {
                String idParam = req.getParameter("id");
                Categorie c = (idParam != null && !idParam.isBlank())
                        ? dao.findById(Long.parseLong(idParam)) : new Categorie();
                c.setNom(req.getParameter("nom").trim());
                if (c.getId() == null) dao.save(c); else dao.update(c);
                req.getSession().setAttribute("succes", "Catégorie enregistrée.");
            }
        } catch (Exception e) { req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage()); }
        resp.sendRedirect(req.getContextPath() + "/categories");
    }
}
