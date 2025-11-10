<%-- 
    Document   : devoluciones
    Created on : 7 nov 2025, 7:22:40 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    request.setAttribute("activePage", "devoluciones");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-arrow-repeat me-2"></i> Gestión de Devoluciones</h2>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalDevolucion">
            <i class="bi bi-plus-lg"></i> Registrar devolución
        </button>
    </div>

    <!-- Filtros -->
    <!-- Filtros -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form id="filtroForm" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filtrar por estado</label>
                    <select id="filtroEstado" class="form-select">
                        <option value="Todos" selected>Todos</option>
                        <option value="Entregado">Entregado</option>
                        <option value="Retrasado">Retrasado</option>
                        <option value="Dañado">Dañado</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Buscar por usuario o libro</label>
                    <input id="busquedaTexto" type="text" class="form-control" placeholder="Ingrese nombre o título">
                </div>
                <div class="col-md-4 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary w-50">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                    <button type="button" id="btnLimpiar" class="btn btn-outline-secondary w-50">
                        <i class="bi bi-x-circle"></i> Limpiar
                    </button>
                </div>
            </form>
        </div>
    </div>


    <!-- Tabla de devoluciones -->
    <div class="card shadow-sm">
        <div class="card-body">
            <table id="tablaDevoluciones" class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Usuario</th>
                        <th>Libro</th>
                        <th>Fecha préstamo</th>
                        <th>Fecha devolución</th>
                        <th>Estado</th>
                        <th>Observaciones</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Ana López</td>
                        <td>Introducción a Java</td>
                        <td>2025-10-25</td>
                        <td>2025-11-05</td>
                        <td><span class="badge bg-success">Entregado</span></td>
                        <td>Sin observaciones</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary btn-editar" title="Editar"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger btn-eliminar" title="Eliminar"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Carlos Pérez</td>
                        <td>Base de Datos Avanzadas</td>
                        <td>2025-10-20</td>
                        <td>2025-11-04</td>
                        <td><span class="badge bg-warning text-dark">Retrasado</span></td>
                        <td>Devolución tardía</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary btn-editar"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger btn-eliminar"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Registrar / Editar Devolución -->
<div class="modal fade" id="modalDevolucion" tabindex="-1" aria-labelledby="modalDevolucionLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalDevolucionLabel"><i class="bi bi-arrow-repeat me-2"></i> Registrar Devolución</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="formDevolucion">
                    <input type="hidden" id="filaEditando">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Usuario</label>
                            <input id="usuarioInput" type="text" class="form-control" placeholder="Nombre del usuario">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Título del libro</label>
                            <input id="libroInput" type="text" class="form-control" placeholder="Título del libro">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha préstamo</label>
                            <input id="prestamoInput" type="date" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha devolución real</label>
                            <input id="devolucionInput" type="date" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Estado del libro</label>
                            <select id="estadoInput" class="form-select">
                                <option>Entregado</option>
                                <option>Retrasado</option>
                                <option>Dañado</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Observaciones</label>
                            <textarea id="observacionesInput" class="form-control" rows="1" placeholder="Escriba observaciones..."></textarea>
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="modalEliminar" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="bi bi-trash"></i> Confirmar eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>¿Seguro que desea eliminar esta devolución?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button id="confirmarEliminar" class="btn btn-danger">Eliminar</button>
            </div>
        </div>
    </div>
</div>

<script>
// --- Buscar / Filtrar ---
    document.getElementById("filtroForm").addEventListener("submit", function (e) {
        e.preventDefault();
        const texto = document.getElementById("busquedaTexto").value.toLowerCase();
        const estado = document.getElementById("filtroEstado").value;
        const filas = document.querySelectorAll("#tablaDevoluciones tbody tr");

        filas.forEach(fila => {
            const usuario = fila.cells[1].innerText.toLowerCase();
            const libro = fila.cells[2].innerText.toLowerCase();
            const estadoFila = fila.cells[5].innerText.trim();

            const coincideTexto = usuario.includes(texto) || libro.includes(texto);
            const coincideEstado = estado === "Todos" || estado === estadoFila;

            fila.style.display = coincideTexto && coincideEstado ? "" : "none";
        });
    });

// --- Editar ---
    document.querySelectorAll(".btn-editar").forEach(btn => {
        btn.addEventListener("click", function () {
            const fila = this.closest("tr");
            document.getElementById("filaEditando").value = fila.rowIndex;
            document.getElementById("usuarioInput").value = fila.cells[1].innerText;
            document.getElementById("libroInput").value = fila.cells[2].innerText;
            document.getElementById("prestamoInput").value = fila.cells[3].innerText;
            document.getElementById("devolucionInput").value = fila.cells[4].innerText;
            document.getElementById("estadoInput").value = fila.cells[5].innerText.trim();
            document.getElementById("observacionesInput").value = fila.cells[6].innerText;

            document.getElementById("modalDevolucionLabel").innerText = "Editar Devolución";
            new bootstrap.Modal(document.getElementById("modalDevolucion")).show();
        });
    });

// --- Guardar cambios o nueva devolución ---
    document.getElementById("formDevolucion").addEventListener("submit", function (e) {
        e.preventDefault();
        const filaIndex = document.getElementById("filaEditando").value;
        const tabla = document.querySelector("#tablaDevoluciones tbody");

        const data = {
            usuario: document.getElementById("usuarioInput").value,
            libro: document.getElementById("libroInput").value,
            prestamo: document.getElementById("prestamoInput").value,
            devolucion: document.getElementById("devolucionInput").value,
            estado: document.getElementById("estadoInput").value,
            observaciones: document.getElementById("observacionesInput").value
        };

        if (filaIndex) {
            const fila = tabla.rows[filaIndex - 1];
            fila.cells[1].innerText = data.usuario;
            fila.cells[2].innerText = data.libro;
            fila.cells[3].innerText = data.prestamo;
            fila.cells[4].innerText = data.devolucion;
            fila.cells[5].innerHTML = `<span class="badge bg-\${data.estado === 'Entregado' ? 'success' : data.estado === 'Retrasado' ? 'warning text-dark' : 'danger'}">\${data.estado}</span>`;
            fila.cells[6].innerText = data.observaciones;
        }

        bootstrap.Modal.getInstance(document.getElementById("modalDevolucion")).hide();
    });

// --- Eliminar ---
    let filaAEliminar = null;
    document.querySelectorAll(".btn-eliminar").forEach(btn => {
        btn.addEventListener("click", function () {
            filaAEliminar = this.closest("tr");
            new bootstrap.Modal(document.getElementById("modalEliminar")).show();
        });
    });

    // --- Limpiar filtros ---
    document.getElementById("btnLimpiar").addEventListener("click", function () {
        document.getElementById("filtroEstado").value = "Todos";
        document.getElementById("busquedaTexto").value = "";

        // Mostrar todas las filas de la tabla
        document.querySelectorAll("#tablaDevoluciones tbody tr").forEach(fila => {
            fila.style.display = "";
        });
    });


    document.getElementById("confirmarEliminar").addEventListener("click", function () {
        if (filaAEliminar)
            filaAEliminar.remove();
        bootstrap.Modal.getInstance(document.getElementById("modalEliminar")).hide();
    });
</script>

<jsp:include page="components/footer.jsp" />


