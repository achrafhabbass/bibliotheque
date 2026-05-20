package ma.bibliotheque.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    private static final String[] PUBLIC = {"/login", "/index.jsp"};

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();

        boolean isPublic = false;
        for (String p : PUBLIC) {
            if (path.startsWith(p)) { isPublic = true; break; }
        }
        if (path.equals("/api") || path.startsWith("/api/")) isPublic = true;

        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        chain.doFilter(req, res);
    }
}
