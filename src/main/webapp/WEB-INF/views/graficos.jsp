<%-- 
    Document   : graficos
    Created on : 7 nov 2025, 7:24:47 p. m.
    Author     : LuisElias
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

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
    
    List<Object[]> listaGenero = (List<Object[]>) request.getAttribute("conteoPorGenero");

    List<String> generos = new ArrayList<>();
    List<Integer> cantidades = new ArrayList<>();

    if (listaGenero != null) {
        for (Object[] fila : listaGenero) {
            generos.add((String) fila[0]);       // nombre del género
            cantidades.add(((Long) fila[1]).intValue()); // cantidad
        }
    }
%>


<%@ include file="components/header.jsp" %>
<%@ include file="components/sidebar.jsp" %>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="container mt-4">
        <h2 class="text-center mb-4">Gráficos</h2>

        <div class="row">
            <!-- Gráfico 1: Libros disponibles vs prestados -->
            <div class="col-md-6 mb-4 text-center">
                <h5>Libros Activos vs Inactivos</h5>
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
            <!-- Gráfico 3: Cantidad de libros por género -->
            <div class="col-md-6 mb-4 text-center">
                <h5>Libros por género</h5>
                <%
                    if (generos.size() > 0) {
                %>
                    <canvas id="generosChart" style="max-height: 300px;"></canvas>
                <%
                    } else {
                %>
                    <p>No hay datos suficientes para graficar géneros.</p>
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
            labels: ['Activos', 'Inactivos'],
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
<% if (generos.size() > 0) { %>
<script>
    const ctxGeneros = document.getElementById('generosChart').getContext('2d');

    const generosLabels = [<%= String.join(", ", generos.stream()
        .map(g -> "\"" + g + "\"")
        .collect(java.util.stream.Collectors.toList())) %>];
    const generosData = [<%= cantidades.stream().map(Object::toString).collect(java.util.stream.Collectors.joining(", ")) %>].map(Number);



    new Chart(ctxGeneros, {
        type: 'pie',
        data: {
            labels: generosLabels,
            datasets: [{
                label: 'Libros por género',
                data: generosData,
                backgroundColor: [
                    '#007bff', '#dc3545', '#28a745',
                    '#ffc107', '#6610f2', '#20c997'
                ],
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const data = context.dataset.data.map(Number);
                            const total = data.reduce((a, b) => a + b, 0);

                            const rawValue = context.raw.parsed !== undefined ? context.raw.parsed : context.raw;
                            const value = Number(rawValue);

                            const porcentaje = ((value / total) * 100).toFixed(2);
                            return `${context.label}: ${value} (${porcentaje}%)`;
                        }

                    }
                }
            }
        }
    });
</script>
<% } %>

<%@ include file="components/footer.jsp" %>