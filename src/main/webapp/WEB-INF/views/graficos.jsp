<%-- 
    Document   : graficos
    Created on : 7 nov 2025, 7:24:47 p. m.
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
    request.setAttribute("activePage", "graficos");
    String rol = (String) session.getAttribute("rol");
    
     int librosDisponibles = (int) request.getAttribute("librosDisponibles");
    int librosPrestados = (int) request.getAttribute("librosPrestados");
    int devolucionesATiempo = (int) request.getAttribute("devolucionesATiempo");
    int devolucionesAtrasadas = (int) request.getAttribute("devolucionesAtrasadas");
%>


<%@ include file="components/header.jsp" %>
<%@ include file="components/sidebar.jsp" %>
<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="container mt-4">
        <h2 class="text-center mb-4">Gráficos</h2>

        <div class="row">
            <!-- Gráfico 1: Libros disponibles vs prestados -->
            <div class="col-md-6 mb-4 text-center">
                <h5>Libros disponibles vs Prestados</h5>
                <%
                    if (librosDisponibles + librosPrestados > 0) {
                %>
                    <canvas id="librosChart" style="max-height: 300px;"></canvas>
                <%
                    } else {
                %>
                    <p>Aún no hay suficientes datos para graficar.</p>
                <%
                    }
                %>
            </div>

            <!-- Gráfico 2: Devoluciones a tiempo vs atrasadas -->
            <div class="col-md-6 mb-4 text-center">
                <h5>Devoluciones a tiempo vs Atrasadas</h5>
                <%
                    if (devolucionesATiempo + devolucionesAtrasadas > 0) {
                %>
                    <canvas id="devolucionesChart" style="max-height: 300px;"></canvas>
                <%
                    } else {
                %>
                    <p>Aún no hay suficientes datos para graficar.</p>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    <% if(librosDisponibles + librosPrestados > 0) { %>
    const ctxLibros = document.getElementById('librosChart').getContext('2d');
    new Chart(ctxLibros, {
        type: 'doughnut',
        data: {
            labels: ['Disponibles', 'Prestados'],
            datasets: [{
                label: 'Libros',
                data: [<%= librosDisponibles %>, <%= librosPrestados %>],
                backgroundColor: ['#28a745', '#dc3545'],
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'bottom' } }
        }
    });
    <% } %>

    <% if(devolucionesATiempo + devolucionesAtrasadas > 0) { %>
    const ctxDevoluciones = document.getElementById('devolucionesChart').getContext('2d');
    new Chart(ctxDevoluciones, {
        type: 'pie',
        data: {
            labels: ['A tiempo', 'Atrasadas'],
            datasets: [{
                label: 'Devoluciones',
                data: [<%= devolucionesATiempo %>, <%= devolucionesAtrasadas %>],
                backgroundColor: ['#007bff', '#ffc107'],
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { position: 'bottom' } }
        }
    });
    <% } %>
</script>
<%@ include file="components/footer.jsp" %>