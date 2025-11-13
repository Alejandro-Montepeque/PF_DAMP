<%-- 
    Document   : prestamos
    Created on : 7 nov 2025, 7:20:44 p. m.
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

    // ✅ Activar link en sidebar
    request.setAttribute("activePage", "prestamos");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<!-- 📦 Contenido principal -->
<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-box-arrow-in-down me-2"></i> Gestión de Préstamos</h2>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoPrestamo">
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
            <table class="table table-striped align-middle text-center" id="tablaPrestamos">
                <thead class="table-primary">
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
                    <tr>
                        <td>1</td>
                        <td>Juan Pérez</td>
                        <td>El Principito</td>
                        <td>2025-11-01</td>
                        <td>2025-11-08</td>
                        <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalEditarPrestamo"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#modalEliminarPrestamo"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Ana Gómez</td>
                        <td>Cien años de soledad</td>
                        <td>2025-10-25</td>
                        <td>2025-11-05</td>
                        <td><span class="badge bg-success">Devuelto</span></td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalEditarPrestamo"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#modalEliminarPrestamo"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 🧾 Modal Nuevo Préstamo -->
<div class="modal fade" id="modalNuevoPrestamo" tabindex="-1" aria-labelledby="modalNuevoPrestamoLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="modalNuevoPrestamoLabel"><i class="bi bi-plus-lg me-2"></i> Registrar Préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Usuario</label>
                            <select class="form-select">
                                <option>Juan Pérez</option>
                                <option>Ana Gómez</option>
                                <option>Marcos Díaz</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Libro</label>
                            <select class="form-select">
                                <option>El Principito</option>
                                <option>Cien años de soledad</option>
                                <option>La Odisea</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de préstamo</label>
                            <input type="date" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de devolución</label>
                            <input type="date" class="form-control">
                        </div>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar préstamo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 📝 Modal Editar Préstamo -->
<div class="modal fade" id="modalEditarPrestamo" tabindex="-1" aria-labelledby="modalEditarPrestamoLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalEditarPrestamoLabel"><i class="bi bi-pencil me-2"></i> Editar Préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Usuario</label>
                            <select class="form-select">
                                <option selected>Juan Pérez</option>
                                <option>Ana Gómez</option>
                                <option>Marcos Díaz</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Libro</label>
                            <select class="form-select">
                                <option selected>El Principito</option>
                                <option>Cien años de soledad</option>
                                <option>La Odisea</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de préstamo</label>
                            <input type="date" class="form-control" value="2025-11-01">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de devolución</label>
                            <input type="date" class="form-control" value="2025-11-08">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Estado</label>
                            <select class="form-select">
                                <option>Pendiente</option>
                                <option selected>Devuelto</option>
                            </select>
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

<!-- ❌ Modal Eliminar -->
<div class="modal fade" id="modalEliminarPrestamo" tabindex="-1" aria-labelledby="modalEliminarPrestamoLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="modalEliminarPrestamoLabel"><i class="bi bi-trash me-2"></i> Eliminar Préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p>¿Está seguro de que desea eliminar este préstamo?</p>
                <strong>Juan Pérez - El Principito</strong>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger">Eliminar</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="components/footer.jsp" />
