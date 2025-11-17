<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    request.setAttribute("activePage", "prestamos");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary">
            <i class="bi bi-box-arrow-in-down me-2"></i> Gestión de Préstamos
        </h2>
        <button class="btn btn-success" id="btnNuevo">
            <i class="bi bi-plus-lg"></i> Nuevo préstamo
        </button>
    </div>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">Buscar por usuario o libro</label>
                    <input type="text" class="form-control" id="buscarPrestamo"
                           placeholder="Ej: Juan Pérez o El Quijote...">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="button" class="btn btn-primary w-100" id="btnBuscar">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabla -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaPrestamos">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Usuario</th>
                            <th>Libro</th>
                            <th>Fecha préstamo</th>
                            <th>Fecha devolución</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:if test="${empty listaPrestamos}">
                            <tr>
                                <td colspan="10" class="text-center text-muted">
                                    No hay préstamos registrados.
                                </td>
                            </tr>
                        </c:if>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="modalPrestamo" tabindex="-1"
     aria-labelledby="modalPrestamoLabel" aria-hidden="true">

    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="modalPrestamoLabel">Registrar Préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form id="formPrestamo" method="post"
                  action="${pageContext.request.contextPath}/PrestamosServlet">

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

                            <!-- Libros -->
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

                            <div class="col-md-6 d-none" id="grupoFechaReal">
                                <label class="form-label">Fecha devolución real</label>
                                <input type="date" id="fechaReal" name="fechaReal" class="form-control">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Estado</label>
                                <select id="estado" name="estado" class="form-control" readonly>
                                    <option value="Pendiente">Pendiente</option>
                                    <option value="Entregado">Entregado</option>
                                </select>
                            </div>

                            <div class="col-12 d-none" id="grupoObservacion">
                                <label class="form-label">Observaciones</label>
                                <textarea id="observaciones" name="observaciones" class="form-control"></textarea>
                            </div>

                        </div> <!-- row -->

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary" id="btnGuardar">Guardar</button>
                        </div>

                    </form>
                </div> <!-- modal-body -->

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Cancelar</button>

                    <button type="submit" class="btn btn-primary"
                            id="btnGuardar">Guardar</button>
                </div>

            </form>
        </div>
    </div>
</div>


<script>
    /* ==== ALERTAS ==== */
    <c:if test="${not empty mensajeExito}">
    mostrarAlertaExito("${mensajeExito}");
    </c:if>

    <c:if test="${not empty mensajeError}">
    mostrarAlertaError("${mensajeError}");
    </c:if>
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {

        /* ==========================
         *   MANEJO DE USUARIOS
         * ========================== */
        const usuarios = JSON.parse('${usuariosJson}');
        const inputUsuario = document.getElementById("buscarUsuario");
        const contenedorUsuario = document.getElementById("resultadosUsuario");

        inputUsuario.addEventListener("input", () => {
            const texto = inputUsuario.value.toLowerCase();
            contenedorUsuario.innerHTML = "";

            if (texto.trim() === "")
                return;

            const filtrados = usuarios.filter(u =>
                u.nombre.toLowerCase().includes(texto) ||
                        u.dui.includes(texto) ||
                        u.email.toLowerCase().includes(texto)
            );

            filtrados.slice(0, 5).forEach(u => {
                const item = document.createElement("button");
                item.classList = "list-group-item list-group-item-action";
                item.textContent = `${u.nombre} (${u.dui})`;

                item.onclick = () => {
                    inputUsuario.value = u.nombre;
                    document.getElementById("idUsuario").value = u.idUsuario;
                    contenedorUsuario.innerHTML = "";
                };
                contenedorUsuario.appendChild(item);
            });
        });

        /* ==========================
         *   MANEJO DE LIBROS
         * ========================== */
        const libros = JSON.parse('${librosJson}');
        const inputLibro = document.getElementById("buscarLibro");
        const contenedorLibro = document.getElementById("resultadosLibro");

        let librosSeleccionados = [];

        function agregarLibro(id, titulo) {
            if (librosSeleccionados.includes(id))
                return;

            librosSeleccionados.push(id);

            const cont = document.getElementById("librosSeleccionados");

            const chip = document.createElement("span");
            chip.classList = "badge bg-primary me-2 p-2";
            chip.innerHTML = `${titulo} <i class="bi bi-x-circle ms-1" style="cursor:pointer"></i>`;

            chip.querySelector("i").onclick = () => {
                chip.remove();
                librosSeleccionados = librosSeleccionados.filter(x => x !== id);
                document.getElementById(`libroHidden_${id}`).remove();
            };

            cont.appendChild(chip);

            const hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "idLibro";
            hidden.value = id;
            hidden.id = "libroHidden_" + id;

            cont.appendChild(hidden);

            inputLibro.value = "";
        }

        inputLibro.addEventListener("input", () => {
            const texto = inputLibro.value.toLowerCase();
            contenedorLibro.innerHTML = "";

            if (!texto.trim())
                return;

            const filtrados = libros.filter(l =>
                l.titulo.toLowerCase().includes(texto) ||
                        (l.isbn && l.isbn.includes(texto))
            );

            filtrados.slice(0, 5).forEach(l => {
                const item = document.createElement("button");
                item.classList = "list-group-item list-group-item-action";
                item.textContent = `${l.titulo} (ISBN: ${l.isbn ? l.isbn : '---'})`;

                item.onclick = () => {
                    contenedorLibro.innerHTML = "";
                    agregarLibro(l.idLibro, l.titulo);
                };

                contenedorLibro.appendChild(item);
            });
        });

        /* ==========================
         *   NUEVO PRÉSTAMO
         * ========================== */
        document.getElementById('btnNuevo').onclick = function () {

            document.getElementById("modalPrestamoLabel").innerHTML =
                    "<i class='bi bi-plus-lg'></i> Nuevo préstamo";

            document.getElementById("formPrestamo").reset();
            document.getElementById("idPrestamo").value = "";

            librosSeleccionados = [];
            document.getElementById("librosSeleccionados").innerHTML = "";

            document.getElementById("grupoFechaReal").classList.add("d-none");
            document.getElementById("grupoObservacion").classList.add("d-none");

            document.getElementById("estado").value = "Pendiente";
            document.getElementById("estado").readonly = true;

            new bootstrap.Modal(document.getElementById("modalPrestamo")).show();
        };

    });
</script>

<jsp:include page="components/footer.jsp" />
