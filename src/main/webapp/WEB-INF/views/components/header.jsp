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
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sistema de Biblioteca</title>

        <!-- ✅ Favicon -->
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/favicon.png">

        <!-- ✅ Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- ✅ Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <!-- ✅ Estilos personalizados -->
        <style>
            body {
                background-color: #f8f9fa;
                font-family: "Poppins", sans-serif;
            }

            .sidebar {
                height: 100vh;
                background-color: #212529;
                color: #fff;
                padding-top: 1rem;
            }

            .sidebar a {
                color: #adb5bd;
                display: block;
                padding: 0.75rem 1rem;
                text-decoration: none;
            }

            .sidebar a.active, .sidebar a:hover {
                background-color: #0d6efd;
                color: #fff;
                border-radius: 0.5rem;
            }

            .navbar {
                background-color: #ffffff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

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
            <div class="container-fluid">

                <!-- 🏛️ Título del sistema -->
                <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/DashboardServlet">
                    <i class="bi bi-book-half me-2"></i> Biblioteca
                </a>

                <!-- 🔔 Parte derecha -->
                <div class="d-flex align-items-center ms-auto">

                    <!-- 👤 Nombre del usuario logeado -->
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

                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-box-arrow-right"></i> Salir
                    </a>

                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row">

