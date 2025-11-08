<%-- 
    Document   : bibliotecarios
    Created on : 7 nov 2025
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
    request.setAttribute("activePage", "bibliotecarios");

    // Rol del usuario
    String rol = (String) session.getAttribute("rol");
%>

<%@ include file="components/header.jsp" %>
<%@ include file="components/sidebar.jsp" %>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary mb-0"><i class="bi bi-person-workspace me-2"></i> Gestión de Bibliotecarios</h2>
        <div>
            <% if ("ADMIN".equals(rol)) { %>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bibliotecarioModal" id="btnNuevo">
                    <i class="bi bi-person-plus me-1"></i> Nuevo Bibliotecario
                </button>
            <% } %>
        </div>
    </div>

    <!-- FILTROS -->
    <div class="card mb-4">
        <div class="card-body">
            <form class="row g-2 align-items-end" id="filtrosForm" onsubmit="return false;">
                <div class="col-sm-4">
                    <label class="form-label small">Turno</label>
                    <select id="filtroTurno" class="form-select">
                        <option value="">Todos</option>
                        <option value="Mañana">Mañana</option>
                        <option value="Tarde">Tarde</option>
                        <option value="Noche">Noche</option>
                    </select>
                </div>

                <div class="col-sm-3">
                    <label class="form-label small">Cargo</label>
                    <select id="filtroCargo" class="form-select">
                        <option value="">Todos</option>
                        <option value="Auxiliar">Auxiliar</option>
                        <option value="Encargado">Encargado</option>
                        <option value="Administrador">Administrador</option>
                    </select>
                </div>

                <div class="col-sm-3">
                    <label class="form-label small">Buscar (nombre, email)</label>
                    <input id="filtroTexto" type="text" class="form-control" placeholder="Buscar...">
                </div>

                <div class="col-sm-2 d-grid">
                    <button class="btn btn-outline-secondary" onclick="resetFiltros()">Limpiar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- TABLA -->
    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaBibliotecarios">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Cargo</th>
                            <th>Turno</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-nombre="Luis Gómez" data-cargo="Encargado" data-turno="Mañana" data-telefono="7000-1111" data-email="luis.gomez@biblioteca.com" data-estado="Activo">
                            <td>1</td>
                            <td>Luis Gómez</td>
                            <td>Encargado</td>
                            <td>Mañana</td>
                            <td>7000-1111</td>
                            <td>luis.gomez@biblioteca.com</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <% if ("ADMIN".equals(rol)) { %>
                                    <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#bibliotecarioModal">Editar</button>
                                    <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <% } %>
                            </td>
                        </tr>

                        <tr data-nombre="Ana Torres" data-cargo="Auxiliar" data-turno="Tarde" data-telefono="7111-2222" data-email="ana.torres@biblioteca.com" data-estado="Activo">
                            <td>2</td>
                            <td>Ana Torres</td>
                            <td>Auxiliar</td>
                            <td>Tarde</td>
                            <td>7111-2222</td>
                            <td>ana.torres@biblioteca.com</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <% if ("ADMIN".equals(rol)) { %>
                                    <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#bibliotecarioModal">Editar</button>
                                    <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <% } %>
                            </td>
                        </tr>

                        <tr data-nombre="Carlos Méndez" data-cargo="Administrador" data-turno="Noche" data-telefono="7333-4444" data-email="carlos.mendez@biblioteca.com" data-estado="Inactivo">
                            <td>3</td>
                            <td>Carlos Méndez</td>
                            <td>Administrador</td>
                            <td>Noche</td>
                            <td>7333-4444</td>
                            <td>carlos.mendez@biblioteca.com</td>
                            <td><span class="badge bg-danger">Inactivo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <% if ("ADMIN".equals(rol)) { %>
                                    <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#bibliotecarioModal">Editar</button>
                                    <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <% } %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3">
                <small class="text-muted">Mostrando 1-3 de 3 bibliotecarios</small>
                <div>
                    <button class="btn btn-sm btn-outline-secondary me-2" onclick="exportarCSV()">Exportar CSV</button>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item disabled"><a class="page-link">Anterior</a></li>
                        <li class="page-item active"><a class="page-link">1</a></li>
                        <li class="page-item disabled"><a class="page-link">Siguiente</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</main>

<!-- Modal: Agregar / Editar Bibliotecario -->
<div class="modal fade" id="bibliotecarioModal" tabindex="-1" aria-labelledby="bibliotecarioModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form id="bibliotecarioForm" class="modal-content needs-validation" novalidate onsubmit="return guardarBibliotecario(event);">
            <div class="modal-header">
                <h5 class="modal-title" id="bibliotecarioModalLabel">Nuevo Bibliotecario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" id="nombre" class="form-control" required>
                        <div class="invalid-feedback">Ingrese el nombre completo.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Correo institucional</label>
                        <input type="email" id="email" class="form-control" required>
                        <div class="invalid-feedback">Ingrese un correo válido.</div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Teléfono</label>
                        <input type="text" id="telefono" class="form-control" required>
                        <div class="invalid-feedback">Ingrese el teléfono.</div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Cargo</label>
                        <select id="cargo" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Auxiliar</option>
                            <option>Encargado</option>
                            <option>Administrador</option>
                        </select>
                        <div class="invalid-feedback">Seleccione el cargo.</div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Turno</label>
                        <select id="turno" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Mañana</option>
                            <option>Tarde</option>
                            <option>Noche</option>
                        </select>
                        <div class="invalid-feedback">Seleccione el turno.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Observaciones</label>
                        <input type="text" id="observaciones" class="form-control">
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

<%@ include file="components/footer.jsp" %>

<!-- Script de manejo visual -->
<script>
    // === Validación Bootstrap ===
    (() => {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    const filtroTurno = document.getElementById('filtroTurno');
    const filtroCargo = document.getElementById('filtroCargo');
    const filtroTexto = document.getElementById('filtroTexto');
    const tabla = document.querySelector('#tablaBibliotecarios tbody');
    let filaEditando = null; // referencia de la fila que se está editando

    // === Filtros ===
    function resetFiltros() {
        filtroTurno.value = '';
        filtroCargo.value = '';
        filtroTexto.value = '';
        aplicarFiltros();
    }

    function aplicarFiltros() {
        const turno = filtroTurno.value.toLowerCase();
        const cargo = filtroCargo.value.toLowerCase();
        const texto = filtroTexto.value.toLowerCase();

        Array.from(tabla.rows).forEach(row => {
            const nombre = row.dataset.nombre.toLowerCase();
            const turnoRow = row.dataset.turno.toLowerCase();
            const cargoRow = row.dataset.cargo.toLowerCase();
            const email = row.dataset.email.toLowerCase();

            const matches =
                (turno === '' || turnoRow === turno) &&
                (cargo === '' || cargoRow === cargo) &&
                (texto === '' || nombre.includes(texto) || email.includes(texto));

            row.style.display = matches ? '' : 'none';
        });
    }

    filtroTurno.addEventListener('change', aplicarFiltros);
    filtroCargo.addEventListener('change', aplicarFiltros);
    filtroTexto.addEventListener('input', aplicarFiltros);

    // === Exportar CSV ===
    function exportarCSV() {
        let csv = 'Nombre,Cargo,Turno,Teléfono,Email,Estado\n';
        Array.from(tabla.rows).forEach(row => {
            if (row.style.display === 'none') return;
            const cols = row.cells;
            csv += `"${cols[1].innerText}","${cols[2].innerText}","${cols[3].innerText}","${cols[4].innerText}","${cols[5].innerText}","${cols[6].innerText}"\n`;
        });
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'bibliotecarios.csv';
        a.click();
        URL.revokeObjectURL(url);
    }

    // === Nuevo Bibliotecario ===
    document.getElementById('btnNuevo')?.addEventListener('click', () => {
        document.getElementById('bibliotecarioModalLabel').innerText = 'Nuevo Bibliotecario';
        document.getElementById('bibliotecarioForm').reset();
        document.getElementById('bibliotecarioForm').classList.remove('was-validated');
        filaEditando = null; // modo nuevo
    });

    // === Guardar (visual) ===
    function guardarBibliotecario(e) {
        e.preventDefault();
        const form = document.getElementById('bibliotecarioForm');
        if (!form.checkValidity()) {
            form.classList.add('was-validated');
            return false;
        }

        const nombre = document.getElementById('nombre').value;
        const email = document.getElementById('email').value;
        const telefono = document.getElementById('telefono').value;
        const cargo = document.getElementById('cargo').value;
        const turno = document.getElementById('turno').value;
        const obs = document.getElementById('observaciones').value;

        if (filaEditando) {
            // === Modo edición ===
            filaEditando.dataset.nombre = nombre;
            filaEditando.dataset.email = email;
            filaEditando.dataset.telefono = telefono;
            filaEditando.dataset.cargo = cargo;
            filaEditando.dataset.turno = turno;
            filaEditando.dataset.observaciones = obs;

            const cols = filaEditando.cells;
            cols[1].innerText = nombre;
            cols[2].innerText = cargo;
            cols[3].innerText = turno;
            cols[4].innerText = telefono;
            cols[5].innerText = email;
        } else {
            // === Nuevo ===
            const next = tabla.rows.length + 1;
            const tr = document.createElement('tr');
            tr.dataset.nombre = nombre;
            tr.dataset.email = email;
            tr.dataset.telefono = telefono;
            tr.dataset.cargo = cargo;
            tr.dataset.turno = turno;
            tr.dataset.estado = "Activo";

            tr.innerHTML = `
                <td>${next}</td>
                <td>${nombre}</td>
                <td>${cargo}</td>
                <td>${turno}</td>
                <td>${telefono}</td>
                <td>${email}</td>
                <td><span class="badge bg-success">Activo</span></td>
                <td class="text-end">
                    <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                    <% if ("ADMIN".equals(rol)) { %>
                        <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#bibliotecarioModal">Editar</button>
                        <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                    <% } %>
                </td>
            `;
            tabla.appendChild(tr);
            inicializarBotonesFila(tr);
        }

        bootstrap.Modal.getInstance(document.getElementById('bibliotecarioModal')).hide();
        return false;
    }

    // === Inicializa eventos para las filas nuevas ===
    function inicializarBotonesFila(tr) {
        tr.querySelector('.btn-ver').addEventListener('click', () => verBibliotecario(tr));
        tr.querySelector('.btn-eliminar').addEventListener('click', () => eliminarBibliotecario(tr));
        tr.querySelector('.btn-editar').addEventListener('click', () => editarBibliotecario(tr));
    }

    // === Eliminar (visual) ===
    function eliminarBibliotecario(tr) {
        if (confirm('¿Eliminar este bibliotecario? (solo visual)')) tr.remove();
    }

    // === Ver (alerta simple) ===
    function verBibliotecario(tr) {
        alert(`Bibliotecario: ${tr.dataset.nombre}\nCargo: ${tr.dataset.cargo}\nTurno: ${tr.dataset.turno}\nEmail: ${tr.dataset.email}`);
    }

    // === Editar (cargar datos en modal) ===
    function editarBibliotecario(tr) {
        filaEditando = tr;
        document.getElementById('bibliotecarioModalLabel').innerText = 'Editar Bibliotecario';
        document.getElementById('nombre').value = tr.dataset.nombre || '';
        document.getElementById('email').value = tr.dataset.email || '';
        document.getElementById('telefono').value = tr.dataset.telefono || '';
        document.getElementById('cargo').value = tr.dataset.cargo || '';
        document.getElementById('turno').value = tr.dataset.turno || '';
        document.getElementById('observaciones').value = tr.dataset.observaciones || '';
    }

    // === Inicializar botones al cargar ===
    document.querySelectorAll('#tablaBibliotecarios tbody tr').forEach(tr => {
        inicializarBotonesFila(tr);
    });
</script>

