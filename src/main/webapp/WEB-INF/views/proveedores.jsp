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
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<!-- Contenido principal -->
<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-building me-2"></i> Gestión de Proveedores / Editoriales / Imprentas</h2>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoProveedor">
            <i class="bi bi-plus-lg"></i> Nuevo proveedor
        </button>
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
        <div class="card-body">
            <table class="table table-striped align-middle text-center" id="tablaProveedores">
                <thead class="table-primary">
                    <tr>
                        <th>#</th>
                        <th>Nombre</th>
                        <th>Tipo</th>
                        <th>Contacto</th>
                        <th>Teléfono</th>
                        <th>Email</th>
                        <th>Dirección</th>
                        <th>Acciones</th>
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
                        <td>
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalEditarProveedor"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#modalEliminarProveedor"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Impresos Modernos</td>
                        <td>Imprenta</td>
                        <td>María López</td>
                        <td>7890-1122</td>
                        <td>ventas@impresosmodernos.com</td>
                        <td>Santa Ana, El Salvador</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalEditarProveedor"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#modalEliminarProveedor"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
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
                            <input type="text" class="form-control" placeholder="Nombre del proveedor">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tipo</label>
                            <select class="form-select">
                                <option selected>Editorial</option>
                                <option>Imprenta</option>
                                <option>Distribuidor</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nombre de contacto</label>
                            <input type="text" class="form-control" placeholder="Persona responsable">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Teléfono</label>
                            <input type="text" class="form-control" placeholder="0000-0000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Correo electrónico</label>
                            <input type="email" class="form-control" placeholder="ejemplo@correo.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Dirección</label>
                            <input type="text" class="form-control" placeholder="Dirección completa">
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

<!--  Modal Editar Proveedor -->
<div class="modal fade" id="modalEditarProveedor" tabindex="-1" aria-labelledby="modalEditarProveedorLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalEditarProveedorLabel"><i class="bi bi-pencil me-2"></i> Editar Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Nombre</label>
                            <input type="text" class="form-control" >
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tipo</label>
                            <select class="form-select">
                                <option selected>Editorial</option>
                                <option>Imprenta</option>
                                <option>Distribuidor</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nombre de contacto</label>
                            <input type="text" class="form-control" >
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Teléfono</label>
                            <input type="text" class="form-control" >
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Correo electrónico</label>
                            <input type="email" class="form-control" >
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Dirección</label>
                            <input type="text" class="form-control" >
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!--  Modal Eliminar -->
<div class="modal fade" id="modalEliminarProveedor" tabindex="-1" aria-labelledby="modalEliminarProveedorLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="modalEliminarProveedorLabel"><i class="bi bi-trash me-2"></i> Eliminar Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p>¿Está seguro de que desea eliminar este proveedor?</p>
                <strong>Editorial Santillana</strong>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger">Eliminar</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="components/footer.jsp" />
