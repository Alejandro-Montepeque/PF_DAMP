<%-- 
    Document   : catalogoLibros
    Created on : 7 nov 2025, 6:25:10 p. m.
    Author     : LuisElias
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // ---> Protección de sesión
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // Página activa para la sidebar
    request.setAttribute("activePage", "libros");
    String rol = (String) session.getAttribute("rol");
%>


<%@ include file="components/header.jsp" %>
<%@ include file="components/sidebar.jsp" %>
<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="container mt-4">
        <h2 class="text-center mb-4">Catálogo de Libros</h2>
    </div>
</main>

<%@ include file="components/footer.jsp" %>

