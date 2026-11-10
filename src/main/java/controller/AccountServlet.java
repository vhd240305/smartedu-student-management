package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;
import java.util.List;

import dao.AccountDAO;

@WebServlet("/admin/accounts")
public class AccountServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
//
		Account acc = (Account) session.getAttribute("account");
//
//		if (acc == null || !acc.getRole().equals("admin")) {
//			response.sendRedirect("../view/auth/login.jsp");
//			return;
//		}

		String action = request.getParameter("action");

		AccountDAO dao = new AccountDAO();

		if (action == null) {
		    int page = 1;
		    int pageSize = 7;
		    try {
		        page = Integer.parseInt(request.getParameter("page"));
		    } catch (Exception e) {}

		    int offset = (page - 1) * pageSize;
		    String keyword = request.getParameter("keyword");

		    int totalRecords;
		    List<Account> list;

		    if (keyword != null && !keyword.trim().isEmpty()) {
		        totalRecords = dao.countSearch(keyword);
		        list = dao.searchWithPaging(keyword, offset, pageSize);
		        request.setAttribute("keyword", keyword);
		    } else {
		        totalRecords = dao.countAll();
		        list = dao.getWithPaging(offset, pageSize);
		    }

		    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

		    request.setAttribute("list", list);
		    request.setAttribute("currentPage", page);
		    request.setAttribute("totalPages", totalPages);

		    request.getRequestDispatcher("/view/admin/account-list.jsp").forward(request, response);

		} else if ("add".equals(action)) {

			request.getRequestDispatcher("/view/admin/account-add.jsp").forward(request, response);

		} else if ("edit".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));

			request.setAttribute("account", dao.getById(id));

			request.getRequestDispatcher("/view/admin/account-edit.jsp").forward(request, response);

		} else if ("delete".equals(action)) {

			int id = Integer.parseInt(request.getParameter("id"));

			dao.delete(id);
			request.getSession().setAttribute("successMsg", "Xóa tài khoản thành công!");
			response.sendRedirect("accounts");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		AccountDAO dao = new AccountDAO();

		if ("insert".equals(action)) {

			Account a = new Account();

			a.setUsername(request.getParameter("username"));
			a.setPassword(request.getParameter("password"));
			a.setRole(request.getParameter("role"));

			dao.insert(a);
			request.getSession().setAttribute("successMsg", "Thêm tài khoản thành công!");

		} else if ("update".equals(action)) {

			Account a = new Account();

			a.setId(Integer.parseInt(request.getParameter("id")));
			a.setUsername(request.getParameter("username"));
			a.setPassword(request.getParameter("password"));
			a.setRole(request.getParameter("role"));
			
			dao.update(a);
			request.getSession().setAttribute("successMsg", "Cập nhật tài khoản thành công!");
		}

		response.sendRedirect("accounts");
	}
}
