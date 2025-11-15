<%-- 
    Document   : proveedores
    Created on : 7 nov 2025, 7:17:48 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar sesión activa
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    //  Activar link en sidebar
    request.setAttribute("activePage", "proveedores");
    String rol = (String) session.getAttribute("rol");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<!-- Contenido principal -->
<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-building me-2"></i> Gestión de Proveedores / Editoriales / Imprentas</h2>
        <% if ("ADMIN".equals(rol)) {
        %>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoProveedor" id="btnNuevo">
            <i class="bi bi-plus-lg"></i> Nuevo proveedor
        </button>
        <%
            }
        %>
    </div>

    <!-- 🔍 Filtro de búsqueda -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">Buscar por nombre o tipo</label>
                    <input type="text" class="form-control" id="buscarProveedor" placeholder="Ej: Santillana, Editorial XYZ...">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="button" class="btn btn-primary w-100" id="btnBuscar">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabla de proveedores -->
    <div class="card shadow-sm">
        <div class="card-body ">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="tablaProveedores">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Contacto</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Dirección</th>
                                <% if ("ADMIN".equals(rol)) {
                                %>
                            <th>Acciones</th>
                                <%
                                    }
                                %>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>Editorial Santillana</td>
                            <td>Editorial</td>
                            <td>Carlos Pérez</td>
                            <td>2222-3333</td>
                            <td>contacto@santillana.com</td>
                            <td>San Salvador, El Salvador</td>
                            <% if ("ADMIN".equals(rol)) {
                            %>
                            <td>
                                <button class="btn btn-sm btn-outline-primary btn-editar" data-bs-toggle="modal" data-bs-target="#modalNuevoProveedor"><i class="bi bi-pencil"></i> Editar</button>                           
                            </td>
                            <%
                                }
                            %>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Nuevo Proveedor -->
<div class="modal fade" id="modalNuevoProveedor" tabindex="-1" aria-labelledby="modalNuevoProveedorLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="modalNuevoProveedorLabel"><i class="bi bi-plus-lg me-2"></i> Registrar Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Nombre</label>
                            <input type="text" class="form-control" placeholder="Nombre del proveedor" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tipo</label>
                            <select class="form-select" name="tipo" required>
                                <option value="">Elegir</option>
                                <option value="">Editorial</option>
                                <option>Imprenta</option>
                                <option>Distribuidor</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nombre de contacto</label>
                            <input type="text" class="form-control" placeholder="Persona responsable" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Teléfono</label>
                            <input type="text" class="form-control" placeholder="0000-0000" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Correo electrónico</label>
                            <input type="email" class="form-control" placeholder="ejemplo@correo.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Dirección</label>
                            <input type="text" class="form-control" placeholder="Dirección completa" required>
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar proveedor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Espera a que la página esté completamente cargada
    document.addEventListener('DOMContentLoaded', function () {

        //const modalForm = document.getElementById('usuarioForm');
        const modalTitle = document.getElementById('modalNuevoProveedorLabel');
        const modalHeader = document.querySelector(".modal-header");

        // 1. Escucha los clics en CUALQUIER botón de "Editar"
        document.querySelectorAll('.btn-editar').forEach(btn => {
            btn.addEventListener('click', function () {

                // Encuentra la fila (<tr>) más cercana al botón
                //const row = this.closest('tr');
                // Lee todos los "data-*" attributes de esa fila
                //const data = row.dataset;

                // --- Rellena el formulario ---
                modalHeader.classList.remove("bg-success", "text-white");
                modalHeader.classList.add("bg-warning", "text-dark");
                modalTitle.innerHTML = "<i class='bi bi-pencil-square'></i> Editar Proveedor"; // Cambia el título


            });
        });

        // 2. Escucha el clic en el botón "Nuevo Usuario"
        document.getElementById('btnNuevo').addEventListener('click', function () {
            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");

            // --- Limpia el formulario ---
            modalTitle.innerHTML = "<i class='bi bi-plus-lg me-2'></i> Registrar Proveedor"; // Restaura el título
            //modalForm.reset(); // Limpia todos los inputs
            //modalForm.classList.remove('was-validated'); // Quita los checks verdes/rojos
            //modalForm.querySelector('#usuarioId').value = ''; // Limpia el ID oculto


        });

    });
</script>
<jsp:include page="components/footer.jsp" />
