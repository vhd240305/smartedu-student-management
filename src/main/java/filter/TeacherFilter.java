package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.Account;
import java.io.IOException;

@WebFilter("/teacher/*")
public class TeacherFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account acc = (session != null) ? (Account) session.getAttribute("account") : null;

        if (acc == null || !"teacher".equals(acc.getRole())) {
            res.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}