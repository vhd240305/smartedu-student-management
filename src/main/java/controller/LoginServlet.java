package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;

import dao.AccountDAO;

@WebServlet("/login1")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginServlet() {
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if (username.isEmpty() || password.isEmpty()) {
			response.sendRedirect("view/auth/login.jsp?error=1");
			return;
		}
		AccountDAO dao = new AccountDAO();

		Account acc = dao.login(username, password);
		if (acc != null) {

			HttpSession session = request.getSession();

			session.setAttribute("account", acc);
			if (acc.getRole().equals("admin")) {

				response.sendRedirect("view/admin/home.jsp");

			} else if (acc.getRole().equals("student")) {

				response.sendRedirect("student/home");

			} else {

				response.sendRedirect("teacher/home");
			}
		} else {

			response.sendRedirect("view/auth/login.jsp?error=1");
		}
	}
}
