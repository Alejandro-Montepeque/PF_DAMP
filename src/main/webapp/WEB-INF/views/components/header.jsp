<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Biblioteca</title>

    <!-- CSS -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/favicon.png">
    <link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/sweetAlert.css" rel="stylesheet">

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/js/sweetAlertEngine.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: "Poppins", sans-serif;
        }

        /* === NAVBAR === */
        .navbar {
            background-color: #ffffff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* === SIDEBAR DESKTOP (FIJO) === */
        .sidebar-fixed {
            position: fixed;
            top: 70px; /* espacio para navbar */
            left: 0;
            height: calc(100vh - 70px);
            width: 240px;
            background-color: #212529;
            overflow-y: auto;
            padding-top: 1rem;
        }

        .sidebar-fixed a {
            color: #adb5bd;
            display: block;
            padding: 0.75rem 1rem;
            text-decoration: none;
        }

        .sidebar-fixed a:hover,
        .sidebar-fixed a.active {
            background-color: #0d6efd;
            color: white !important;
            border-radius: 0.5rem;
        }

        /* === CONTENIDO PRINCIPAL === */
        .content-wrapper {
            margin-left: 240px; /* mismo ancho de sidebar */
            padding: 20px;
        }
    </style>
</head>

<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-light bg-white px-3 border-bottom shadow-sm sticky-top">
    <div class="container-fluid d-flex align-items-center">

        <!-- Botón menú móvil -->
        <button class="btn btn-primary d-md-none me-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMobile">
            <i class="bi bi-list"></i>
        </button>

        <!-- Logo / Título -->
        <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/DashboardServlet">
            <i class="bi bi-book-half me-2"></i> Biblioteca
        </a>

        <div class="ms-auto d-flex align-items-center">
            <% String usuario = (String) session.getAttribute("usuario"); %>
            <% if (usuario != null) { %>
                <span class="me-3 fw-semibold text-dark">
                    <i class="bi bi-person-circle me-1"></i> <%= usuario %>
                </span>
            <% } %>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right"></i> Salir
            </a>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
