<%-- 
    Document   : reportes
    Created on : 7 nov 2025, 7:24:22 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ✅ Verificar sesión activa
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // ✅ Activar menú lateral
    request.setAttribute("activePage", "reportes");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-file-earmark-text me-2"></i> Reportes del Sistema</h2>
        <div>
            <button id="btnExcel" class="btn btn-outline-success me-2"><i class="bi bi-file-earmark-excel"></i> Exportar Excel</button>
            <button id="btnPDF" class="btn btn-outline-danger me-2"><i class="bi bi-file-earmark-pdf"></i> Exportar PDF</button>
            <button id="btnPrint" class="btn btn-outline-secondary"><i class="bi bi-printer"></i> Imprimir</button>
        </div>
    </div>

    <!-- 🔍 Filtros -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form id="filtroReportes" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Tipo de reporte</label>
                    <select id="tipoReporte" class="form-select">
                        <option selected>Catálogo de Libros</option>
                        <option>Proveedores / Editoriales</option>
                        <option>Autores</option>
                        <option>Usuarios</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Filtrar por género</label>
                    <select id="filtroGenero" class="form-select">
                        <option value="Todos" selected>Todos</option>
                        <option value="Novela">Novela</option>
                        <option value="Infantil">Infantil</option>
                        <option value="Educativo">Educativo</option>
                        <option value="Ciencia">Ciencia</option>
                        <option value="Tecnología">Tecnología</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Filtrar por autor</label>
                    <input id="filtroAutor" type="text" class="form-control" placeholder="Nombre del autor">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Filtrar por estado</label>
                    <select id="filtroEstado" class="form-select">
                        <option value="Todos" selected>Todos</option>
                        <option value="Disponible">Disponible</option>
                        <option value="No disponible">No disponible</option>
                    </select>
                </div>
                <div class="col-12 d-flex justify-content-end gap-2">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Buscar</button>
                    <button type="button" id="btnLimpiar" class="btn btn-outline-secondary"><i class="bi bi-x-circle"></i> Limpiar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 📋 Tabla de Reportes -->
    <div class="card shadow-sm">
        <div class="card-body">
            <h5 id="tituloReporte" class="card-title mb-3">📚 Reporte: Catálogo de Libros</h5>
            <table id="tablaReportes" class="table table-striped align-middle">
                <thead id="encabezados">
                    <!-- Se llenan dinámicamente -->
                </thead>
                <tbody>
                    <!-- Aquí se insertan las filas -->
                </tbody>
            </table>
        </div>
    </div>
</div>


<script>
    document.addEventListener("DOMContentLoaded", () => {
        const tipoReporteSelect = document.getElementById("tipoReporte");
        const tituloReporte = document.getElementById("tituloReporte");
        const tablaBody = document.querySelector("#tablaReportes tbody");

        // Datos de ejemplo: un objeto para cada tipo de reporte
        const reportesData = {
            "Catálogo de Libros": [
                {id: 1, titulo: "Programación en Java", autor: "Juan Pérez", genero: "Tecnología", año: 2022, editorial: "AlfaOmega", estado: "Disponible"},
                {id: 2, titulo: "Literatura Clásica", autor: "María Gómez", genero: "Novela", año: 2019, editorial: "Editorial Centroamérica", estado: "No disponible"},
                {id: 3, titulo: "Introducción a las Bases de Datos", autor: "Carlos Ruiz", genero: "Educativo", año: 2021, editorial: "UCA Press", estado: "Disponible"}
            ],
            "Proveedores / Editoriales": [
                {id: 1, nombre: "AlfaOmega", pais: "México", telefono: "+52 555 000 1234", contacto: "Laura López"},
                {id: 2, nombre: "UCA Press", pais: "El Salvador", telefono: "+503 2222 1111", contacto: "Carlos Méndez"}
            ],
            "Autores": [
                {id: 1, nombre: "Juan Pérez", nacionalidad: "Salvadoreño", librosPublicados: 5},
                {id: 2, nombre: "María Gómez", nacionalidad: "Guatemalteca", librosPublicados: 3}
            ],
            "Usuarios": [
                {id: 1, nombre: "Luis Hernández", tipo: "Administrador", correo: "lhernandez@biblioteca.com"},
                {id: 2, nombre: "Ana Torres", tipo: "Lector", correo: "atorres@gmail.com"},
                {id: 3, nombre: "Carlos García", tipo: "Lector", correo: "cgarcia@hotmail.com"}
            ]
        };

        // 🧾 Función para renderizar tabla según el tipo de reporte
        function renderTabla(tipo) {
            tablaBody.innerHTML = ""; // Limpiar contenido previo
            let html = "";

            if (tipo === "Catálogo de Libros") {
                html = reportesData[tipo].map(d => `
                <tr>
                    <td>\${d.id}</td>
                    <td>\${d.titulo}</td>
                    <td>\${d.autor}</td>
                    <td>\${d.genero}</td>
                    <td>\${d.año}</td>
                    <td>\${d.editorial}</td>
                    <td><span class="badge bg-\${d.estado === "Disponible" ? "success" : "danger"}">\${d.estado}</span></td>
                </tr>
            `).join("");
                document.querySelector("#encabezados").innerHTML = `
                <tr>
                    <th>#</th><th>Título</th><th>Autor</th><th>Género</th><th>Año</th><th>Editorial</th><th>Estado</th>
                </tr>`;
            } else if (tipo === "Proveedores / Editoriales") {
                html = reportesData[tipo].map(d => `
                <tr>
                    <td>\${d.id}</td>
                    <td>\${d.nombre}</td>
                    <td>\${d.pais}</td>
                    <td>\${d.telefono}</td>
                    <td>\${d.contacto}</td>
                </tr>
            `).join("");
                document.querySelector("#encabezados").innerHTML = `
                <tr><th>#</th><th>Nombre</th><th>País</th><th>Teléfono</th><th>Contacto</th></tr>`;
            } else if (tipo === "Autores") {
                html = reportesData[tipo].map(d => `
                <tr>
                    <td>\${d.id}</td>
                    <td>\${d.nombre}</td>
                    <td>\${d.nacionalidad}</td>
                    <td>\${d.librosPublicados}</td>
                </tr>
            `).join("");
                document.querySelector("#encabezados").innerHTML = `
                <tr><th>#</th><th>Nombre</th><th>Nacionalidad</th><th>Libros publicados</th></tr>`;
            } else if (tipo === "Usuarios") {
                html = reportesData[tipo].map(d => `
                <tr>
                    <td>\${d.id}</td>
                    <td>\${d.nombre}</td>
                    <td>\${d.tipo}</td>
                    <td>\${d.correo}</td>
                </tr>
            `).join("");
                document.querySelector("#encabezados").innerHTML = `
                <tr><th>#</th><th>Nombre</th><th>Tipo</th><th>Correo</th></tr>`;
            }

            tablaBody.innerHTML = html;
            tituloReporte.textContent = `📚 Reporte: \${tipo}`;
        }

        // Detectar cambio en el select
        tipoReporteSelect.addEventListener("change", () => {
            renderTabla(tipoReporteSelect.value);
        });

        //  Render inicial
        renderTabla("Catálogo de Libros");

        tipoReporteSelect.addEventListener("change", () => {
            const tipo = tipoReporteSelect.value;
            renderTabla(tipo);

            //  Filtros específicos del catálogo de libros
            const filtrosLibros = document.querySelectorAll("#filtroGenero, #filtroAutor, #filtroEstado");
            filtrosLibros.forEach(f => f.closest(".col-md-3").style.display = tipo === "Catálogo de Libros" ? "" : "none");

            // Botones de buscar y limpiar
            const botones = document.querySelectorAll("#filtroReportes button");
            botones.forEach(b => b.style.display = tipo === "Catálogo de Libros" ? "" : "none");
        });




        document.getElementById("filtroReportes").addEventListener("submit", function (e) {
            e.preventDefault();

            const tipoReporte = document.getElementById("tipoReporte").value;
            const genero = document.getElementById("filtroGenero").value.toLowerCase();
            const autor = document.getElementById("filtroAutor").value.toLowerCase();
            const estado = document.getElementById("filtroEstado").value.toLowerCase();

            document.getElementById("tituloReporte").innerText = "📚 Reporte: " + tipoReporte;

            // Solo filtra si es el catálogo de libros
            if (tipoReporte !== "Catálogo de Libros") {
                alert("🔍 Los filtros solo aplican al catálogo de libros.");
                return;
            }

            const filas = document.querySelectorAll("#tablaReportes tbody tr");

            filas.forEach(fila => {
                const generoFila = fila.cells[3].innerText.toLowerCase();
                const autorFila = fila.cells[2].innerText.toLowerCase();
                const estadoFila = fila.cells[6].innerText.toLowerCase();

                const coincideGenero = genero === "todos" || generoFila.includes(genero);
                const coincideAutor = autor === "" || autorFila.includes(autor);
                const coincideEstado = estado === "todos" || estadoFila === estado;


                fila.style.display = (coincideGenero && coincideAutor && coincideEstado) ? "" : "none";
            });
        });

// Limpiar filtros
        document.getElementById("btnLimpiar").addEventListener("click", function () {
            document.getElementById("tipoReporte").value = "Catálogo de Libros";
            document.getElementById("filtroGenero").value = "Todos";
            document.getElementById("filtroAutor").value = "";
            document.getElementById("filtroEstado").value = "Todos";
            document.getElementById("tituloReporte").innerText = "📚 Reporte: Catálogo de Libros";

            document.querySelectorAll("#tablaReportes tbody tr").forEach(fila => {
                fila.style.display = "";
            });
        });

//Simulación de exportar / imprimir
        document.getElementById("btnExcel").addEventListener("click", () => alert("📗 Exportando a Excel..."));
        document.getElementById("btnPDF").addEventListener("click", () => alert("📕 Exportando a PDF..."));
        document.getElementById("btnPrint").addEventListener("click", () => window.print());
    });
</script>


<jsp:include page="components/footer.jsp" />

