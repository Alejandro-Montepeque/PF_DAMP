<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null || rol == null) {

        String cookieUsuario = null;
        String cookieRol = null;

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("usuario".equals(c.getName())) {
                    cookieUsuario = c.getValue();
                }
                if ("rol".equals(c.getName())) {
                    cookieRol = c.getValue();
                }
            }
        }

        //Si ambas cookies existen, reconstruimos sesión
        if (cookieUsuario != null && cookieRol != null) {
            HttpSession nuevaSesion = request.getSession(true);
            nuevaSesion.setAttribute("usuario", cookieUsuario);
            nuevaSesion.setAttribute("rol", cookieRol);

            // Y enviamos al dashboard
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
            return;
        }
    }

    //Si no hay sesión ni cookies → ir al login
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    } else {
        response.sendRedirect(request.getContextPath() + "/DashboardServlet");
    }
%>

