<%-- 
    Document   : header
    Created on : 7 nov 2025, 5:02:33 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <link href="${pageContext.request.contextPath}/css/sweetAlert.css" rel="stylesheet">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sistema de Biblioteca</title>
        <script src="${pageContext.request.contextPath}/js/sweetAlertEngine.js"></script>
        <!--  Favicon -->
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/favicon.png">
        <!--  Bootstrap 5 -->
        <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">

        <!--  Bootstrap Icons -->
        <link href="${pageContext.request.contextPath}/css/bootstrap-icons.css" rel="stylesheet">


        <!--  Estilos personalizados -->
        <style>
            body {
                background-color: #f8f9fa;
                font-family: "Poppins", sans-serif;
            }

            /* ===== Sidebar (Escritorio y Móvil) ===== */
            .sidebar {
                background-color: #212529;
                color: #fff;
            }

            /* Sidebar en escritorio */
            .sidebar.d-md-block {
                height: 100vh;
                padding-top: 1rem;
            }

            /* Sidebar móvil (offcanvas) */
            .sidebar.offcanvas {
                width: 260px; /* tamaño adecuado */
                padding-top: 1rem;
            }

            /* Enlaces del menú */
            .sidebar a {
                color: #adb5bd;
                display: block;
                padding: 0.75rem 1rem;
                text-decoration: none;
                transition: background-color 0.2s ease, color 0.2s ease;
            }

            /* Hover + Active */
            .sidebar a.active,
            .sidebar a:hover {
                background-color: #0d6efd;
                color: #fff !important;
                border-radius: 0.5rem;
            }

            /* Navbar */
            .navbar {
                background-color: #ffffff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            /* Footer */
            footer {
                background-color: #fff;
                padding: 1rem;
                text-align: center;
                border-top: 1px solid #dee2e6;
            }
        </style>
    </head>


    <body class="bg-light">

        <nav class="navbar navbar-expand-lg navbar-light bg-white px-3 border-bottom shadow-sm">
            <div class="container-fluid d-flex align-items-center">

                <!-- 🔵 Botón menú móvil (a la izquierda, estilo estándar) -->
                <button class="btn btn-primary d-md-none me-2"
                        type="button"
                        data-bs-toggle="offcanvas"
                        data-bs-target="#sidebarMobile">
                    <i class="bi bi-list"></i>
                </button>

                <!-- 🏛️ Título del sistema -->
                <a class="navbar-brand fw-bold text-primary" 
                   href="${pageContext.request.contextPath}/DashboardServlet">
                    <i class="bi bi-book-half me-2"></i> Biblioteca
                </a>

                <!-- 🔔 Parte derecha -->
                <div class="ms-auto d-flex align-items-center">

                    <!-- 👤 Nombre del usuario -->
                    <%
                        String usuario = (String) session.getAttribute("usuario");
                        if (usuario != null) {
                    %>
                    <span class="me-3 fw-semibold text-dark">
                        <i class="bi bi-person-circle me-1"></i> <%= usuario%>
                    </span>
                    <%
                        }
                    %>

                    <!-- 🔴 Logout -->
                    <a href="${pageContext.request.contextPath}/LogoutServlet" 
                       class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-box-arrow-right"></i> Salir
                    </a>
                </div>
            </div>
        </nav>


        <div class="container-fluid">
            <div class="row">

