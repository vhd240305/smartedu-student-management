package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Account;
import dao.AccountDAO;

import java.io.IOException;

@WebServlet("/student/change-password")
public class StudentChangePasswordServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");
//
//		if (acc == null || !"student".equals(acc.getRole())) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		request.getRequestDispatcher("/view/student/change-password.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		Account acc = (Account) session.getAttribute("account");

		String oldPass = request.getParameter("oldPassword");
		String newPass = request.getParameter("newPassword");
		String confirm = request.getParameter("confirmPassword");

		if (!newPass.equals(confirm)) {
			request.setAttribute("error", "Mật khẩu xác nhận không khớp");
			request.getRequestDispatcher("/view/student/change-password.jsp").forward(request, response);
			return;
		}

		AccountDAO dao = new AccountDAO();

		boolean success = dao.changePassword(acc.getId(), oldPass, newPass);

		if (success) {
			request.setAttribute("msg", "Đổi mật khẩu thành công");
		} else {
			request.setAttribute("error", "Mật khẩu cũ không chính xác");
		}

		request.getRequestDispatcher("/view/student/change-password.jsp").forward(request, response);
	}
}