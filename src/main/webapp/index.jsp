<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario != null) {
        response.sendRedirect(request.getContextPath() + "/DashboardServlet");
    } else {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    }
%>

