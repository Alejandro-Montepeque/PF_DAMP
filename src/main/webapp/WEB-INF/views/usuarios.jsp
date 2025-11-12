<%-- 
    Document   : usuarios
    Created on : 7 nov 2025, 5:45:12 p. m.
    Author     : LuisElias
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // Protege la vista: si no hay sesión, redirige al login
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // Indicamos la página activa para el sidebar
    request.setAttribute("activePage", "usuarios");

    // Rol de la sesión (puede ser "ADMIN" o "USER")
    String rol = (String) session.getAttribute("rol");
%>

<%@ include file="components/header.jsp" %>
<!-- ✅ Sidebar -->
<%@ include file="components/sidebar.jsp" %>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary mb-0"><i class="bi bi-people me-2"></i> Gestión de Usuarios</h2>
        <div>
            <!-- Botón visible solo para admins -->
            <% if ("ADMIN".equals(rol)) {
            %>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#usuarioModal" id="btnNuevo">
                <i class="bi bi-person-plus me-1"></i> Nuevo Usuario
            </button>
            <%
                }
            %>
        </div>
    </div>

    <!-- FILTROS -->
    <div class="card mb-4">
        <div class="card-body">
            <form class="row g-2 align-items-end" id="filtrosForm" onsubmit="return false;">
                <div class="col-sm-4">
                    <label class="form-label small">Tipo de usuario</label>
                    <select id="filtroTipo" class="form-select">
                        <option value="">Todos</option>
                        <option value="Estudiante">Estudiante</option>
                        <option value="Docente">Docente</option>
                        <option value="Externo">Externo</option>
                    </select>
                </div>

                <div class="col-sm-3">
                    <label class="form-label small">Sexo</label>
                    <select id="filtroSexo" class="form-select">
                        <option value="">Todos</option>
                        <option value="Masculino">Masculino</option>
                        <option value="Femenino">Femenino</option>
                        <option value="Otro">Otro</option>
                    </select>
                </div>

                <div class="col-sm-3">
                    <label class="form-label small">Buscar (nombre, DUI, email)</label>
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
                <table class="table table-hover align-middle" id="tablaUsuarios">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Edad</th>
                            <th>Sexo</th>
                            <th>DUI</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Datos estáticos -->
                        <tr data-nombre="María Pérez" data-tipo="Estudiante" data-sexo="Femenino" data-dui="01234567-8" data-telefono="7777-7777" data-email="maria.perez@ejemplo.com" data-fecha="2003-04-15" data-direccion="Av. Central #123" data-estado="Activo">
                            <td>1</td>
                            <td>María Pérez</td>
                            <td>Estudiante</td>
                            <td>22</td>
                            <td>Femenino</td>
                            <td>01234567-8</td>
                            <td>7777-7777</td>
                            <td>maria.perez@ejemplo.com</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver" title="Ver">Ver</button>
                                <%
                                    if ("ADMIN".equals(rol)) {
                                %>
                                <button class="btn btn-sm btn-outline-primary me-1 btn-editar" title="Editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button>
                                <button class="btn btn-sm btn-outline-danger btn-eliminar" title="Eliminar">Eliminar</button>
                                <%
                                    }
                                %>
                            </td>
                        </tr>

                        <tr data-nombre="Carlos López" data-tipo="Docente" data-sexo="Masculino" data-dui="02345678-9" data-telefono="7888-8888" data-email="carlos.lopez@ejemplo.edu" data-fecha="1980-11-02" data-direccion="Calle 5 #45" data-estado="Activo">
                            <td>2</td>
                            <td>Carlos López</td>
                            <td>Docente</td>
                            <td>43</td>
                            <td>Masculino</td>
                            <td>02345678-9</td>
                            <td>7888-8888</td>
                            <td>carlos.lopez@ejemplo.edu</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <%
                                    if ("ADMIN".equals(rol)) {
                                %>
                                <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button>
                                <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <%
                                    }
                                %>
                            </td>
                        </tr>

                        <tr data-nombre="Laura Martínez" data-tipo="Externo" data-sexo="Femenino" data-dui="03456789-0" data-telefono="7999-9999" data-email="laura.m@ejemplo.com" data-fecha="1995-06-10" data-direccion="Col. Los Pinos" data-estado="Moroso">
                            <td>3</td>
                            <td>Laura Martínez</td>
                            <td>Externo</td>
                            <td>28</td>
                            <td>Femenino</td>
                            <td>03456789-0</td>
                            <td>7999-9999</td>
                            <td>laura.m@ejemplo.com</td>
                            <td><span class="badge bg-danger">Moroso</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <%
                                    if ("ADMIN".equals(rol)) {
                                %>
                                <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button>
                                <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <%
                                    }
                                %>
                            </td>
                        </tr>

                        <tr data-nombre="Jorge Ramírez" data-tipo="Estudiante" data-sexo="Masculino" data-dui="04567890-1" data-telefono="7222-2222" data-email="jorge.r@ejemplo.com" data-fecha="2002-09-20" data-direccion="Barrio El Centro" data-estado="Activo">
                            <td>4</td>
                            <td>Jorge Ramírez</td>
                            <td>Estudiante</td>
                            <td>21</td>
                            <td>Masculino</td>
                            <td>04567890-1</td>
                            <td>7222-2222</td>
                            <td>jorge.r@ejemplo.com</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <%
                                    if ("ADMIN".equals(rol)) {
                                %>
                                <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button>
                                <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <%
                                    }
                                %>
                            </td>
                        </tr>

                        <tr data-nombre="Ana Gómez" data-tipo="Docente" data-sexo="Femenino" data-dui="05678901-2" data-telefono="7111-1111" data-email="ana.gomez@ejemplo.edu" data-fecha="1978-02-28" data-direccion="Res. Las Flores" data-estado="Activo">
                            <td>5</td>
                            <td>Ana Gómez</td>
                            <td>Docente</td>
                            <td>47</td>
                            <td>Femenino</td>
                            <td>05678901-2</td>
                            <td>7111-1111</td>
                            <td>ana.gomez@ejemplo.edu</td>
                            <td><span class="badge bg-success">Activo</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
                                <%
                                    if ("ADMIN".equals(rol)) {
                                %>
                                <button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button>
                                <button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>
                                <%
                                    }
                                %>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

            <!-- Pie: paginación / export (visual) -->
            <div class="d-flex justify-content-between align-items-center mt-3">
                <small class="text-muted">Mostrando 1-5 de 5 usuarios</small>
                <div>
                    <button class="btn btn-sm btn-outline-secondary me-2" onclick="exportarCSV()">Exportar CSV</button>
                    <nav aria-label="Paginación">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled"><a class="page-link">Anterior</a></li>
                            <li class="page-item active"><a class="page-link">1</a></li>
                            <li class="page-item disabled"><a class="page-link">Siguiente</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

</main>

<!-- Modal: Agregar / Editar Usuario -->
<div class="modal fade" id="usuarioModal" tabindex="-1" aria-labelledby="usuarioModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form id="usuarioForm" class="modal-content needs-validation" novalidate onsubmit="return guardarUsuario(event);">
            <div class="modal-header">
                <h5 class="modal-title" id="usuarioModalLabel">Nuevo Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12 col-md-12 col-lg-6">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" id="nombre" class="form-control" required>
                        <div class="invalid-feedback">Ingrese el nombre completo.</div>
                    </div>

                    <div class="col-12 col-sm-6 col-md-6 col-lg-3">
                        <label class="form-label">Fecha de nacimiento</label>
                        <input type="date" id="fechaNacimiento" class="form-control" required>
                        <div class="invalid-feedback">Seleccione la fecha de nacimiento.</div>
                    </div>

                    <div class="col-12 col-sm-6 col-md-6 col-lg-3">
                        <label class="form-label">Sexo</label>
                        <select id="sexo" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Masculino</option>
                            <option>Femenino</option>
                            <option>Otro</option>
                        </select>
                        <div class="invalid-feedback">Seleccione el sexo.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Dirección completa</label>
                        <input type="text" id="direccion" class="form-control" required>
                        <div class="invalid-feedback">Ingrese la dirección.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">DUI</label>
                        <input type="text" id="dui" class="form-control" placeholder="00000000-0" required>
                        <div class="invalid-feedback">Ingrese el DUI.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Teléfono</label>
                        <input type="text" id="telefono" class="form-control" required>
                        <div class="invalid-feedback">Ingrese el teléfono.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" id="email" class="form-control" required>
                        <div class="invalid-feedback">Ingrese un email válido.</div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tipo de usuario</label>
                        <select id="tipoUsuario" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Estudiante</option>
                            <option>Docente</option>
                            <option>Externo</option>
                        </select>
                        <div class="invalid-feedback">Seleccione el tipo de usuario.</div>
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

<!-- Scripts específicos de usuarios (visual) -->
<script>
    // Validación básica Bootstrap
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })();

    // ---- Filtrado simple en el DOM (visual)
    const filtroTipo = document.getElementById('filtroTipo');
    const filtroSexo = document.getElementById('filtroSexo');
    const filtroTexto = document.getElementById('filtroTexto');
    const tabla = document.getElementById('tablaUsuarios').getElementsByTagName('tbody')[0];

    function resetFiltros() {
        filtroTipo.value = '';
        filtroSexo.value = '';
        filtroTexto.value = '';
        aplicarFiltros();
    }

    function aplicarFiltros() {
        const tipo = filtroTipo.value.toLowerCase();
        const sexo = filtroSexo.value.toLowerCase();
        const texto = filtroTexto.value.toLowerCase();

        Array.from(tabla.rows).forEach(row => {
            const nombre = row.dataset.nombre.toLowerCase();
            const tipoRow = row.dataset.tipo ? row.dataset.tipo.toLowerCase() : '';
            const sexoRow = row.dataset.sexo ? row.dataset.sexo.toLowerCase() : '';
            const dui = row.dataset.dui ? row.dataset.dui.toLowerCase() : '';
            const email = row.dataset.email ? row.dataset.email.toLowerCase() : '';

            const matches = (tipo === '' || tipoRow === tipo)
                    && (sexo === '' || sexoRow === sexo)
                    && (texto === '' || nombre.includes(texto) || dui.includes(texto) || email.includes(texto));

            row.style.display = matches ? '' : 'none';
        });
    }

    filtroTipo.addEventListener('change', aplicarFiltros);
    filtroSexo.addEventListener('change', aplicarFiltros);
    filtroTexto.addEventListener('input', aplicarFiltros);

    // ---- Exportar CSV (visual)
    function exportarCSV() {
        let csv = 'Nombre,Tipo,Sexo,DUI,Teléfono,Email,Estado\\n';
        Array.from(tabla.rows).forEach(row => {
            if (row.style.display === 'none')
                return;
            const cols = row.cells;
            const nombre = cols[1].innerText.trim();
            const tipo = cols[2].innerText.trim();
            const sexo = cols[4].innerText.trim();
            const dui = cols[5].innerText.trim();
            const tel = cols[6].innerText.trim();
            const email = cols[7].innerText.trim();
            const estado = cols[8].innerText.trim();
            csv += `"${nombre}","${tipo}","${sexo}","${dui}","${tel}","${email}","${estado}"\\n`;
        });
        const blob = new Blob([csv], {type: 'text/csv;charset=utf-8;'});
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'usuarios.csv';
        a.click();
        URL.revokeObjectURL(url);
    }

    // ---- Manejo modal: rellenar datos para editar
    document.querySelectorAll('.btn-editar').forEach(btn => {
        btn.addEventListener('click', function (e) {
            const row = this.closest('tr');
            // Rellenar formulario con datos del data-*
            document.getElementById('usuarioModalLabel').innerText = 'Editar Usuario';
            document.getElementById('nombre').value = row.dataset.nombre || '';
            document.getElementById('fechaNacimiento').value = row.dataset.fecha || '';
            document.getElementById('sexo').value = row.dataset.sexo || '';
            document.getElementById('direccion').value = row.dataset.direccion || '';
            document.getElementById('dui').value = row.dataset.dui || '';
            document.getElementById('telefono').value = row.dataset.telefono || '';
            document.getElementById('email').value = row.dataset.email || '';
            document.getElementById('tipoUsuario').value = row.dataset.tipo || '';
            // abrir modal (ya lo hace el data-bs-toggle cuando se cliquea el botón)
        });
    });

    // ---- Manejo modal: nuevo usuario (limpiar)
    document.getElementById('btnNuevo')?.addEventListener('click', function () {
        document.getElementById('usuarioModalLabel').innerText = 'Nuevo Usuario';
        document.getElementById('usuarioForm').reset();
        document.getElementById('usuarioForm').classList.remove('was-validated');
    });

    // ---- Guardar (visual): agregamos la fila en la tabla (solo frontend)
    function guardarUsuario(event) {
        event.preventDefault();
        const form = document.getElementById('usuarioForm');
        if (!form.checkValidity()) {
            form.classList.add('was-validated');
            return false;
        }

        // Crear fila nueva (solo visual)
        const nombre = document.getElementById('nombre').value;
        const tipo = document.getElementById('tipoUsuario').value;
        const sexo = document.getElementById('sexo').value;
        const fecha = document.getElementById('fechaNacimiento').value;
        const direccion = document.getElementById('direccion').value;
        const dui = document.getElementById('dui').value;
        const telefono = document.getElementById('telefono').value;
        const email = document.getElementById('email').value;


        const tbody = document.getElementById('tablaUsuarios').getElementsByTagName('tbody')[0];
        const nextIndex = tbody.rows.length + 1;
        const tr = document.createElement('tr');

        tr.setAttribute('data-nombre', nombre);
        tr.setAttribute('data-tipo', tipo);
        tr.setAttribute('data-sexo', sexo);
        tr.setAttribute('data-dui', dui);
        tr.setAttribute('data-telefono', telefono);
        tr.setAttribute('data-email', email);
        tr.setAttribute('data-fecha', fecha);
        tr.setAttribute('data-direccion', direccion);

        tr.innerHTML = `
            <td>${nextIndex}</td>
            <td>${nombre}</td>
            <td>${tipo}</td>
            <td>-</td>
            <td>${sexo}</td>
            <td>${dui}</td>
            <td>${telefono}</td>
            <td>${email}</td>
            <td><span class="badge bg-success">Activo</span></td>
            <td class="text-end">
                <button class="btn btn-sm btn-outline-secondary me-1 btn-ver">Ver</button>
    ${ "ADMIN".equals(rol) ? '<button class="btn btn-sm btn-outline-primary me-1 btn-editar" data-bs-toggle="modal" data-bs-target="#usuarioModal">Editar</button><button class="btn btn-sm btn-outline-danger btn-eliminar">Eliminar</button>' : '' }
            </td>
        `;
        tbody.appendChild(tr);

        // Cerrar modal
        const modalEl = document.getElementById('usuarioModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal)
            modal.hide();

        return false;
    }

    // ---- Botones eliminar (visual)
    document.querySelectorAll('.btn-eliminar').forEach(btn => {
        btn.addEventListener('click', function () {
            if (!confirm('¿Eliminar este usuario? (solo visual)'))
                return;
            const row = this.closest('tr');
            row.remove();
        });
    });

    // ---- Botones ver (muestra modal simple)
    document.querySelectorAll('.btn-ver').forEach(btn => {
        btn.addEventListener('click', function () {
            const row = this.closest('tr');
            alert(
                    'Usuario: ' + row.dataset.nombre + '\\n' +
                    'Tipo: ' + row.dataset.tipo + '\\n' +
                    'DUI: ' + row.dataset.dui + '\\n' +
                    'Email: ' + row.dataset.email
                    );
        });
    });
</script>
