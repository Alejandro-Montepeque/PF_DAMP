<%-- 
    Document   : login
    Created on : 7 nov 2025, 7:17:33 a. m.
    Author     : LuisElias
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Iniciar Sesión | Sistema de Biblioteca</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .login-card {
                background-color: #fff;
                border-radius: 1rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                padding: 2rem;
                width: 100%;
                max-width: 400px;
            }
            .form-control:focus {
                border-color: #0d6efd;
                box-shadow: none;
            }
        </style>
    </head>
    <body>

        <div class="login-card">
            <div class="text-center mb-4">
                <i class="bi bi-book-half text-primary" style="font-size: 3rem;"></i>
                <h4 class="mt-2 fw-bold">Sistema de Biblioteca</h4>
                <p class="text-muted">Inicie sesión para continuar</p>
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) {%>
            <div class="alert alert-danger text-center mt-3">
                <%= error%>
            </div>
            <% }%>


            <!-- Formulario de Login -->
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="mb-3">
                    <label for="usuario" class="form-label">Usuario</label>
                    <input type="text" class="form-control" id="email" name="email" placeholder="Ingrese su email" required>
                </div>
                <div class="mb-3">
                    <label for="clave" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="clave" name="clave" placeholder="Ingrese su contraseña" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
                </div>
            </form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

