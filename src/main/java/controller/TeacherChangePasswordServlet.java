package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Account;
import dao.AccountDAO;

import java.io.IOException;

import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet("/teacher/change-password")
public class TeacherChangePasswordServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Account acc = (Account) session.getAttribute("account");

//		if (acc == null || !"teacher".equals(acc.getRole())) {
//			response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
//			return;
//		}

		request.getRequestDispatcher("/view/teacher/change-password.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

		if (acc == null || !"teacher".equals(acc.getRole())) {
			response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
			return;
		}

		String oldPass = request.getParameter("oldPassword");
		String newPass = request.getParameter("newPassword");
		String confirm = request.getParameter("confirmPassword");

		// Validate confirm password
		if (confirm == null || !newPass.equals(confirm)) {
			request.setAttribute("error", "Mật khẩu xác nhận không khớp");
			request.getRequestDispatcher("/view/teacher/change-password.jsp").forward(request, response);
			return;
		}

		BCrypt.Result result = BCrypt.verifyer().verify(oldPass.toCharArray(), acc.getPassword());
		if (!result.verified) {
			request.setAttribute("error", "Mật khẩu cũ không chính xác");
			request.getRequestDispatcher("/view/teacher/change-password.jsp").forward(request, response);
			return;
		}

		AccountDAO dao = new AccountDAO();

		dao.changePassword(acc.getId(), newPass);

		request.setAttribute("msg", "Đổi mật khẩu thành công");
		request.getRequestDispatcher("/view/teacher/change-password.jsp").forward(request, response);
	}
}