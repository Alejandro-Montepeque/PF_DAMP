<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- SIDEBAR DESKTOP FIJO -->
<div class="d-none d-md-block sidebar-fixed">
    <ul class="nav flex-column">

        <li class="nav-item">
            <a class="nav-link <%="dashboard".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/DashboardServlet">
                <i class="bi bi-house-door me-2"></i> Inicio
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="libros".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/LibrosServlet">
                <i class="bi bi-book me-2"></i> Libros
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="usuarios".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/UsuariosServlet">
                <i class="bi bi-people me-2"></i> Usuarios
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="bibliotecarios".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/BibliotecariosServlet">
                <i class="bi bi-person-gear me-2"></i> Bibliotecarios
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="proveedores".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/ProveedoresServlet">
                <i class="bi bi-building me-2"></i> Proveedores
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="prestamos".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/PrestamosServlet">
                <i class="bi bi-box-arrow-in-down me-2"></i> Préstamos
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="reportes".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/ReportesServlet">
                <i class="bi bi-file-earmark-text me-2"></i> Reportes
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link <%="graficos".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/GraficosServlet">
                <i class="bi bi-bar-chart-line me-2"></i> Gráficos
            </a>
        </li>

    </ul>
</div>


<!-- SIDEBAR MÓVIL (OFFCANVAS) -->
<div class="offcanvas offcanvas-start d-md-none sidebar bg-dark text-white" tabindex="-1" id="sidebarMobile">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title">Menú</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
    </div>

    <div class="offcanvas-body p-0">
        <ul class="nav flex-column">

            <li class="nav-item">
                <a class="nav-link text-white <%="dashboard".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/DashboardServlet">
                    <i class="bi bi-house-door me-2"></i> Inicio
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="libros".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/LibrosServlet">
                    <i class="bi bi-book me-2"></i> Libros
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="usuarios".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/UsuariosServlet">
                    <i class="bi bi-people me-2"></i> Usuarios
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="bibliotecarios".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/BibliotecariosServlet">
                    <i class="bi bi-person-gear me-2"></i> Bibliotecarios
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="proveedores".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/ProveedoresServlet">
                    <i class="bi bi-building me-2"></i> Proveedores
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="prestamos".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/PrestamosServlet">
                    <i class="bi bi-box-arrow-in-down me-2"></i> Préstamos
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="reportes".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/ReportesServlet">
                    <i class="bi bi-file-earmark-text me-2"></i> Reportes
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link text-white <%="graficos".equals(request.getAttribute("activePage")) ? "active" : ""%>" href="${pageContext.request.contextPath}/GraficosServlet">
                    <i class="bi bi-bar-chart-line me-2"></i> Gráficos
                </a>
            </li>

        </ul>
    </div>
</div>