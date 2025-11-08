<%-- 
    Document   : dashboard
    Created on : 7 nov 2025, 5:05:28 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%request.setAttribute("activePage", "dashboard");%>
<!-- ✅ Encabezado + Navbar -->
<%@ include file="components/header.jsp" %>
<!-- ✅ Sidebar -->
<%@ include file="components/sidebar.jsp" %>
<!-- ✅ Contenido principal -->
<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary mb-0">
            <i class="bi bi-speedometer2 me-2"></i> Panel Principal
        </h2>
        <span class="text-muted">
            Bienvenido, <strong><%= usuario %></strong> 👋
        </span>
    </div>

    <p class="lead text-secondary">Este es tu panel del Sistema de Información de la Biblioteca.</p>

    <!-- 📊 Tarjetas resumen -->
    <div class="row mt-4 g-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-book display-5 text-primary mb-2"></i>
                    <h5 class="card-title fw-semibold">Libros registrados</h5>
                    <p class="card-text fs-3 fw-bold text-dark mb-0">125</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-people display-5 text-success mb-2"></i>
                    <h5 class="card-title fw-semibold">Usuarios activos</h5>
                    <p class="card-text fs-3 fw-bold text-dark mb-0">45</p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body text-center">
                    <i class="bi bi-arrow-left-right display-5 text-warning mb-2"></i>
                    <h5 class="card-title fw-semibold">Préstamos en curso</h5>
                    <p class="card-text fs-3 fw-bold text-dark mb-0">12</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 📈 Sección inferior -->
    <div class="mt-5">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <h5 class="fw-bold text-secondary">
                    <i class="bi bi-info-circle me-2"></i> Información del sistema
                </h5>
                <p class="text-muted mb-0">
                    Desde este panel puedes acceder a todos los módulos del sistema: gestión de libros, usuarios, préstamos, devoluciones, proveedores, reportes y más.
                </p>
            </div>
        </div>
    </div>
</main>

<!-- ✅ Footer -->
<%@ include file="components/footer.jsp" %>


