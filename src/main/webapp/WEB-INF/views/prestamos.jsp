<%-- 
    Document   : prestamos
    Created on : 7 nov 2025, 7:20:44 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Verificar sesión activa
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // Activar link en sidebar
    request.setAttribute("activePage", "prestamos");
    String rol = (String) session.getAttribute("rol");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<!-- 📦 Contenido principal -->
<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-box-arrow-in-down me-2"></i> Gestión de Préstamos</h2>
        <button class="btn btn-success" id="btnNuevo" >
            <i class="bi bi-plus-lg"></i> Nuevo préstamo
        </button>
    </div>

    <!-- 🔍 Filtro de búsqueda -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">Buscar por usuario o libro</label>
                    <input type="text" class="form-control" id="buscarPrestamo" placeholder="Ej: Juan Pérez o El Quijote...">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="button" class="btn btn-primary w-100" id="btnBuscar">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 📋 Tabla de préstamos -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaPrestamos">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Usuario</th>
                            <th>Libro</th>
                            <th>Fecha de préstamo</th>
                            <th>Fecha de devolución</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        

                        <c:if test="${empty listaPrestamos}">
                            <tr>
                                <td colspan="10" class="text-center text-muted">No hay préstamos registrados.</td>
                            </tr>
                        </c:if>
                   </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Nuevo/Editar Préstamo -->
<div class="modal fade" id="modalPrestamo" tabindex="-1" aria-labelledby="modalPrestamoLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="modalPrestamoLabel">Registrar Préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formPrestamo" method="post" action="${pageContext.request.contextPath}/PrestamosServlet">

                    <input type="hidden" id="idPrestamo" name="idPrestamo">
                    <div class="row g-3">

                        <!-- Usuario -->
                        <div class="col-md-6">
                            <input type="hidden" id="idUsuario" name="idUsuario" required>
                            <label class="form-label">Usuario</label>
                            <input type="text" id="buscarUsuario" class="form-control" placeholder="Buscar usuario..." >
                            <div id="resultadosUsuario" class="list-group mt-1"></div>
                        </div>

                        <!-- Libros (múltiples) -->
                        <div class="col-md-6">
                            <label class="form-label">Libro(s)</label>
                            <input type="text" id="buscarLibro" class="form-control" placeholder="Buscar libro..." required>
                            <div id="resultadosLibro" class="list-group mt-1"></div>

                            <!-- Lista de libros seleccionados -->
                            <div class="mt-2" id="librosSeleccionados"></div>
                        </div>

                        <!-- Fecha préstamo -->
                        <div class="col-md-6">
                            <label class="form-label">Fecha de préstamo</label>
                            <input type="date" id="fechaPrestamo" name="fechaPrestamo" class="form-control" required>
                        </div>

                        <!-- Fecha estimada -->
                        <div class="col-md-6">
                            <label class="form-label">Fecha devolución estimada</label>
                            <input type="date" id="fechaEstimada" name="fechaEstimada" class="form-control" required>
                        </div>

                        <!-- Fecha real entrega (solo edición) -->
                        <div class="col-md-6 d-none" id="grupoFechaReal">
                            <label class="form-label">Fecha devolución real</label>
                            <input type="date" id="fechaReal" name="fechaReal" class="form-control">
                        </div>

                        <!-- Estado -->
                        <div class="col-md-6">
                            <label class="form-label">Estado</label>
                            <select id="estado" name="estado" class="form-control" readonly>
                                <option value="Pendiente">Pendiente</option>
                                <option value="Entregado">Entregado</option>
                            </select>
                        </div>

                        <!-- Observaciones -->
                        <div class="col-12 d-none" id="grupoObservacion">
                            <label class="form-label">Observaciones</label>
                            <textarea id="observaciones" name="observaciones" class="form-control"></textarea>
                        </div>

                    </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary" id="btnGuardar">Guardar</button>
            </div>

            </form>
        </div>
    </div>
</div>


</div>
<script>
    <c:if test="${not empty mensajeExito}">
    mostrarAlertaExito("${mensajeExito}");
    </c:if>
    <c:if test="${not empty mensajeError}">
    mostrarAlertaError("${mensajeError}");
    </c:if>
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {

        /* ---------------------------------------------------------
         *  BUSCADOR DE USUARIOS
         * ---------------------------------------------------------*/
        const usuarios = JSON.parse('${usuariosJson}');
        const inputUsuario = document.getElementById("buscarUsuario");
        const contenedorUsuario = document.getElementById("resultadosUsuario");

        inputUsuario.addEventListener("input", () => {
            const texto = inputUsuario.value.toLowerCase();

            if (texto.trim() === "") {
                contenedorUsuario.innerHTML = "";
                return;
            }

            const filtrados = usuarios.filter(u =>
                u.nombre.toLowerCase().includes(texto) ||
                        u.dui.includes(texto) ||
                        u.email.toLowerCase().includes(texto)
            );

            contenedorUsuario.innerHTML = "";

            filtrados.slice(0, 5).forEach(u => {
                const item = document.createElement("button");
                item.classList = "list-group-item list-group-item-action";
                item.textContent = `\${u.nombre} (\${u.dui})`;

                item.onclick = () => {
                    inputUsuario.value = u.nombre;
                    contenedorUsuario.innerHTML = "";
                    document.getElementById("idUsuario").value = u.idUsuario;
                };

                contenedorUsuario.appendChild(item);
            });
        });


        /* ---------------------------------------------------------
         *  BUSCADOR DE LIBROS → MULTI-SELECCIÓN
         * ---------------------------------------------------------*/
        const libros = JSON.parse('${librosJson}');
        const inputLibro = document.getElementById("buscarLibro");
        const contenedorLibro = document.getElementById("resultadosLibro");

        let librosSeleccionados = []; // ← lista de IDs únicos


        // Función para agregar libros al modal
        function agregarLibro(id, titulo) {
            if (librosSeleccionados.includes(id))
                return;

            librosSeleccionados.push(id);

            const contenedor = document.getElementById("librosSeleccionados");

            // Crear chip visual
            const chip = document.createElement("span");
            chip.classList = "badge bg-primary me-2 p-2";
            chip.innerHTML = `\${titulo} <i class="bi bi-x-circle ms-1" style="cursor:pointer"></i>`;

            // Borrar libro
            chip.querySelector("i").onclick = () => {
                chip.remove();
                librosSeleccionados = librosSeleccionados.filter(x => x !== id);
                document.querySelector(`#libroHidden_\${id}`).remove();
            };

            contenedor.appendChild(chip);

            // Hidden input
            const hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "idLibro";
            hidden.value = id;
            hidden.id = "libroHidden_" + id;

            contenedor.appendChild(hidden);

            inputLibro.value = ""; // limpiar campo
        }


        inputLibro.addEventListener("input", () => {
            const texto = inputLibro.value.toLowerCase();

            if (texto.trim() === "") {
                contenedorLibro.innerHTML = "";
                return;
            }

            const filtrados = libros.filter(l =>
                l.titulo.toLowerCase().includes(texto) ||
                        (l.isbn && l.isbn.includes(texto))
            );

            contenedorLibro.innerHTML = "";

            filtrados.slice(0, 5).forEach(l => {
                const item = document.createElement("button");
                item.classList = "list-group-item list-group-item-action";
                item.textContent = `\${l.titulo} (ISBN: \${l.isbn ?? '---'})`;

                // Al seleccionar → agregar libro
                item.onclick = () => {
                    contenedorLibro.innerHTML = "";
                    agregarLibro(l.idLibro, l.titulo);
                };

                contenedorLibro.appendChild(item);
            });
        });


        /* ---------------------------------------------------------
         *  LOGICA DE NUEVO Y EDITAR PRÉSTAMO
         * ---------------------------------------------------------*/
        const modalHeader = document.querySelector(".modal-header");


        /* --- BOTÓN EDITAR --- */
        document.addEventListener("click", function (e) {

            const btn = e.target.closest(".btn-editar");
            if (!btn)
                return;

            const fila = btn.closest("tr");

            modalHeader.classList.remove("bg-success", "text-white");
            modalHeader.classList.add("bg-warning", "text-dark");

            document.getElementById("modalPrestamoLabel").innerHTML =
                    "<i class='bi bi-pencil-square'></i> Editar préstamo";

            // Datos básicos
            document.getElementById("idPrestamo").value = fila.dataset.id;
            document.getElementById("idUsuario").value = fila.dataset.idusuario;
            document.getElementById("buscarUsuario").value = fila.dataset.usuario;

            // --- LIBROS ---
            librosSeleccionados = [];
            document.getElementById("librosSeleccionados").innerHTML = "";

            // Los libros vienen como string "1:El Principito,4:Clean Code"
            if (fila.dataset.libros) {
                fila.dataset.libros.split(",").forEach(item => {
                    const [idLibro, titulo] = item.split(":");
                    agregarLibro(idLibro, titulo);
                });
            }

            // Fechas
            document.getElementById("fechaPrestamo").value = fila.dataset.fechaprestamo;
            document.getElementById("fechaEstimada").value = fila.dataset.fechaestimada;
            document.getElementById("fechaReal").value = fila.dataset.fechareal || "";

            document.getElementById("fechaPrestamo").readonly = true;
            document.getElementById("fechaEstimada").readonly = true;

            document.getElementById("grupoFechaReal").classList.remove("d-none");
            document.getElementById("grupoObservacion").classList.remove("d-none");

            // Estado
            document.getElementById("estado").readonly = false;
            document.getElementById("estado").value = fila.dataset.estado;

            // Observaciones
            document.getElementById("observaciones").value = fila.dataset.observacion || "";

            new bootstrap.Modal(document.getElementById("modalPrestamo")).show();
        });



        /* --- BOTÓN NUEVO --- */
        document.getElementById('btnNuevo').addEventListener('click', function () {

            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");

            document.getElementById("modalPrestamoLabel").innerHTML =
                    "<i class='bi bi-plus-lg'></i> Nuevo préstamo";

            document.getElementById("formPrestamo").reset();
            document.getElementById("idPrestamo").value = "";

            // Reset multi-libros
            librosSeleccionados = [];
            document.getElementById("librosSeleccionados").innerHTML = "";

            // Campos visibles/invisibles
            document.getElementById("grupoFechaReal").classList.add("d-none");
            document.getElementById("grupoObservacion").classList.add("d-none");

            // Estado fijo
            document.getElementById("estado").value = "Pendiente";
            document.getElementById("estado").readonly = true;

            // Fechas editables
            document.getElementById("fechaPrestamo").readonly = false;
            document.getElementById("fechaEstimada").readonly = false;

            new bootstrap.Modal(document.getElementById("modalPrestamo")).show();
        });

    });
</script>

<jsp:include page="components/footer.jsp" />
