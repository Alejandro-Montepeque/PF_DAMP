<%-- 
    Document   : usuarios
    Created on : 7 nov 2025, 5:45:12 p. m.
    Author     : LuisElias
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // si no hay sesión, redirige al login
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    request.setAttribute("activePage", "bibliotecarios");

    String rol = (String) session.getAttribute("rol");
%>

<%@ include file="components/header.jsp" %>

<%@ include file="components/sidebar.jsp" %>

<main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary mb-0"><i class="bi bi-people me-2"></i> Gestión de Bibliotecarios / Admins</h2>
        <div>
            <%                if ("ADMIN".equals(rol)) {
            %>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#usuarioModal" id="btnNuevo">
                <i class="bi bi-person-plus me-1"></i> Nuevo Usuario
            </button>
            <%
                }
            %>
        </div>
    </div>


    <div class="card mb-4">
        <div class="card-body">

            <!-- 
              El formulario apunta al 'doGet' del UsuariosServlet.
              Quitamos el 'onsubmit="return false;"'.
            -->
            <form class="row g-2 align-items-end" 
                  id="filtrosForm" 
                  method="GET" 
                  action="${pageContext.request.contextPath}/BibliotecariosServlet">

                <!-- Filtro 1: Elige la columna por la que buscar -->
                <div class="col-sm-4">
                    <label class="form-label small">Filtrar por</label>
                    <select id="filtroCampo" name="filtroCampo" class="form-select">
                        <!-- 
                          'value' debe ser el nombre del ATRIBUTO en tu 
                          clase modelo 'Usuario.java'
                        -->
                        <option value="nombre">Nombre</option>
                        <option value="dui">DUI</option>
                        <option value="email">Email</option>
                    </select>
                </div>

                <!-- Filtro 2: El texto a buscar -->
                <div class="col-sm-4">
                    <label class="form-label small">Valor</label>
                    <input id="filtroValor" name="filtroValor" type="text" class="form-control" placeholder="Escribe tu búsqueda...">
                </div>

                <!-- Botón de Buscar -->
                <div class="col-sm-2 d-grid">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </div>

                <!-- Botón de Refrescar (es un link al servlet sin parámetros) -->
                <div class="col-sm-2 d-grid">
                    <a href="${pageContext.request.contextPath}/BibliotecariosServlet" class="btn btn-outline-secondary">Refrescar</a>
                </div>
            </form>
        </div>
    </div>



    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaUsuarios">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Sexo</th>
                            <th>DUI</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="usuario" items="${listaUsuarios}" varStatus="loop">

                            <tr data-nombre="${usuario.nombre}"
                                data-sexo="${usuario.sexo}"
                                data-dui="${usuario.dui}"
                                data-telefono="${usuario.telefono}"
                                data-email="${usuario.email}"
                                data-fecha="${usuario.fechaNacimiento}"
                                data-direccion="${usuario.direccion}"
                                data-estado="${usuario.activo ? 'Activo' : 'Inactivo'}"
                                data-id="${usuario.idUsuario}"
                                data-rol-id="${usuario.idRol.idRol}">

                                <td>${loop.count}</td>
                                <td>${usuario.nombre}</td>
                                <td>${usuario.sexo}</td>
                                <td>${usuario.dui}</td>
                                <td>${usuario.telefono}</td>
                                <td>${usuario.email}</td>
                                <td>
                                    <c:if test="${usuario.activo}">
                                        <span class="badge bg-success">Activo</span>
                                    </c:if>
                                    <c:if test="${!usuario.activo}">
                                        <span class="badge bg-danger">Inactivo</span>
                                    </c:if>
                                </td>
                                <td class="text-end">
                                    <%
                                        if ("ADMIN".equals(rol)) {
                                    %>
                                    <button class="btn btn-sm btn-outline-primary me-1 btn-editar" title="Editar" data-bs-toggle="modal" data-bs-target="#usuarioModal"><i class="bi bi-pencil"></i>  Editar</button>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listaUsuarios}">
                            <tr>
                                <td colspan="10" class="text-center text-muted">No se encontraron usuarios registrados.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</div>

</main>

<!-- Modal: Agregar / Editar Usuario -->
<div class="modal fade" id="usuarioModal" tabindex="-1" aria-labelledby="usuarioModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <form id="usuarioForm" 
              method="post" 
              action="${pageContext.request.contextPath}/BibliotecariosServlet" 
              class="modal-content needs-validation" novalidate>

            <div class="modal-header">
                <h5 class="modal-title" id="usuarioModalLabel">Nuevo Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">
                <input type="hidden" id="usuarioId" name="usuarioId">
                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" id="nombre" name="nombre" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Fecha de nacimiento</label>
                        <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Sexo</label>
                        <select id="sexo" name="sexo" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Masculino</option>
                            <option>Femenino</option>
                            <option>Otro</option>
                        </select>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Dirección completa</label>
                        <input type="text" id="direccion" name="direccion" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">DUI</label>
                        <input type="text" id="dui" name="dui" class="form-control" placeholder="00000000-0" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Teléfono</label>
                        <input type="text" id="telefono" name="telefono" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Contraseña</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Confirmar Contraseña</label>
                        <input type="password" id="passwordConfirm" name="passwordConfirm" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Rol</label>
                        <select id="rolUsuario" name="rolUsuario" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option value="1">ADMIN</option>
                            <option value="2">BIBLIOTECARIO</option>
                        </select>
                    </div>
                    <div class="col-md-6 d-flex align-items-center">
                        <div class="form-check form-switch mt-3">
                            <input class="form-check-input" type="checkbox" id="activo" name="activo" checked>
                            <label class="form-check-label" for="activo">Usuario Activo</label>
                        </div>
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
<script>
    <c:if test="${not empty mensajeExito}">
    mostrarAlertaExito("${mensajeExito}");
    </c:if>
    <c:if test="${not empty mensajeError}">
    mostrarAlertaError("${mensajeError}");
    </c:if>
</script>
<script>
    // Espera a que la página esté completamente cargada
    document.addEventListener('DOMContentLoaded', function () {

        const modalEl = document.getElementById('usuarioModal');
        const modalForm = document.getElementById('usuarioForm');
        const modalTitle = document.getElementById('usuarioModalLabel');
        const modalHeader = document.querySelector(".modal-header");

        // 1. Escucha los clics en CUALQUIER botón de "Editar"
        document.querySelectorAll('.btn-editar').forEach(btn => {
            btn.addEventListener('click', function () {

                // Encuentra la fila (<tr>) más cercana al botón
                const row = this.closest('tr');
                // Lee todos los "data-*" attributes de esa fila
                const data = row.dataset;

                // --- Rellena el formulario ---
                modalHeader.classList.remove("bg-success", "text-white");
                modalHeader.classList.add("bg-warning", "text-dark");
                modalTitle.innerHTML = "<i class='bi bi-pencil-square'></i> Editar Usuario."; // Cambia el título

                // Rellena el ID oculto
                modalForm.querySelector('#usuarioId').value = data.id;

                // Rellena los campos de texto
                modalForm.querySelector('#nombre').value = data.nombre;
                modalForm.querySelector('#fechaNacimiento').value = data.fecha;
                modalForm.querySelector('#direccion').value = data.direccion;
                modalForm.querySelector('#dui').value = data.dui;
                modalForm.querySelector('#telefono').value = data.telefono;
                modalForm.querySelector('#email').value = data.email;

                // Rellena los <select>
                modalForm.querySelector('#sexo').value = data.sexo;
                modalForm.querySelector('#rolUsuario').value = data.rolId; // Usamos el data-rol-id

                // Rellena el switch "Activo"
                modalForm.querySelector('#activo').checked = (data.estado === 'Activo');

                // --- Lógica de Contraseña para Editar ---
                // Hacemos que la contraseña sea opcional al editar
                modalForm.querySelector('#password').required = false;
                modalForm.querySelector('#passwordConfirm').required = false;
                modalForm.querySelector('#password').placeholder = "Dejar en blanco para no cambiar";
                modalForm.querySelector('#passwordConfirm').placeholder = "Dejar en blanco para no cambiar";
            });
        });

        // 2. Escucha el clic en el botón "Nuevo Usuario"
        document.getElementById('btnNuevo').addEventListener('click', function () {
            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");

            // --- Limpia el formulario ---
            modalTitle.innerHTML = "<i class='bi bi-person-plus me-1'></i> Nuevo Usuario"; // Restaura el título
            modalForm.reset(); // Limpia todos los inputs
            modalForm.classList.remove('was-validated'); // Quita los checks verdes/rojos
            modalForm.querySelector('#usuarioId').value = ''; // Limpia el ID oculto

            // --- Lógica de Contraseña para Nuevo ---
            // Hacemos que la contraseña sea obligatoria
            modalForm.querySelector('#password').required = true;
            modalForm.querySelector('#passwordConfirm').required = true;
            modalForm.querySelector('#password').placeholder = "";
            modalForm.querySelector('#passwordConfirm').placeholder = "";
        });

    });
</script>
