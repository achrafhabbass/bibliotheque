package ma.bibliotheque.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.bibliotheque.dao.ClientDao;
import ma.bibliotheque.entities.Client;
import java.io.IOException;
import java.util.List;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {

    private final ClientDao dao = new ClientDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        try {
            if ("edit".equals(action)) {
                req.setAttribute("clientEdit", dao.findById(Long.parseLong(req.getParameter("id"))));
            } else {
                String q = req.getParameter("q");
                List<Client> list = (q != null && !q.isBlank()) ? dao.search(q) : dao.findAll();
                req.setAttribute("clients", list);
                req.setAttribute("q", q);
            }
            req.getRequestDispatcher("/WEB-INF/views/clients.jsp").forward(req, resp);
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                dao.delete(Long.parseLong(req.getParameter("id")));
                req.getSession().setAttribute("succes", "Client supprimé.");
            } else {
                String idParam = req.getParameter("id");
                Client c = (idParam != null && !idParam.isBlank())
                        ? dao.findById(Long.parseLong(idParam)) : new Client();
                c.setNom(req.getParameter("nom").trim());
                c.setPrenom(req.getParameter("prenom").trim());
                c.setEmail(req.getParameter("email").trim());
                c.setTelephone(req.getParameter("telephone").trim());
                if (c.getId() == null) dao.save(c); else dao.update(c);
                req.getSession().setAttribute("succes", "Client enregistré.");
            }
        } catch (Exception e) { req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage()); }
        resp.sendRedirect(req.getContextPath() + "/clients");
    }
}
