<%-- 
    Document   : sidebar
    Created on : 7 nov 2025, 5:03:46 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- 🧭 Sidebar -->
<div class="col-md-3 col-lg-2 d-md-block sidebar collapse p-0">
    <div class="position-sticky">
        <ul class="nav flex-column">

            <li class="nav-item">
                <a class="nav-link <%="dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/DashboardServlet">
                    <i class="bi bi-house-door me-2"></i> Inicio
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="libros".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/LibrosServlet">
                    <i class="bi bi-book me-2"></i> Libros
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="usuarios".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/UsuariosServlet">
                    <i class="bi bi-people me-2"></i> Usuarios
                </a>
            </li>

            <!-- 🧑‍🏫 Bibliotecarios -->
            <li class="nav-item">
                <a class="nav-link <%="bibliotecarios".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/BibliotecariosServlet">
                    <i class="bi bi-person-gear me-2"></i> Bibliotecarios
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="proveedores".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/ProveedoresServlet">
                    <i class="bi bi-building me-2"></i> Proveedores
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="prestamos".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/PrestamosServlet">
                    <i class="bi bi-box-arrow-in-down me-2"></i> Préstamos
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="devoluciones".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/DevolucionesServlet">
                    <i class="bi bi-arrow-repeat me-2"></i> Devoluciones
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="reportes".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/ReportesServlet">
                    <i class="bi bi-file-earmark-text me-2"></i> Reportes
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link <%="graficos".equals(request.getAttribute("activePage")) ? "active" : "" %>"
                   href="${pageContext.request.contextPath}/GraficosServlet">
                    <i class="bi bi-bar-chart-line me-2"></i> Gráficos
                </a>
            </li>

        </ul>
    </div>
</div>
