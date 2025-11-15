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
    String rol = (String) session.getAttribute("rol");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<!-- 📦 Contenido principal -->
<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-box-arrow-in-down me-2"></i> Gestión de Préstamos</h2>
        <% if ("ADMIN".equals(rol)) {
        %>
        <button class="btn btn-success" id="btnNuevo" data-bs-toggle="modal" data-bs-target="#modalNuevoPrestamo">
            <i class="bi bi-plus-lg"></i> Nuevo préstamo
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
                            <td>Juan Pérez</td>
                            <td>El Principito</td>
                            <td>2025-11-01</td>
                            <td>2025-11-08</td>
                            <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                            <% if ("ADMIN".equals(rol)) {
                            %>
                            <td>
                                <button class="btn btn-sm btn-outline-primary btn-editar" data-bs-toggle="modal" data-bs-target="#modalNuevoPrestamo"><i class="bi bi-pencil"></i> Editar</button>                                                   
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

<!-- Modal Nuevo Préstamo -->
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
                            <select class="form-select" required>
                                <option value="">Elegir...</option>
                                <option>Juan Pérez</option>
                                <option>Ana Gómez</option>
                                <option>Marcos Díaz</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Libro</label>
                            <select class="form-select" required>
                                <option value="">Elegir...</option>
                                <option>El Principito</option>
                                <option>Cien años de soledad</option>
                                <option>La Odisea</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de préstamo</label>
                            <input type="date" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Fecha de devolución</label>
                            <input type="date" class="form-control" required>
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


<script>
    // Espera a que la página esté completamente cargada
    document.addEventListener('DOMContentLoaded', function () {

        //const modalForm = document.getElementById('usuarioForm');
        const modalTitle = document.getElementById('modalNuevoPrestamoLabel');
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
                modalTitle.innerHTML = "<i class='bi bi-pencil-square'></i> Editar préstamo"; // Cambia el título


            });
        });

        // 2. Escucha el clic en el botón "Nuevo Usuario"
        document.getElementById('btnNuevo').addEventListener('click', function () {
            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");

            // --- Limpia el formulario ---
            modalTitle.innerHTML = "<i class='bi bi-plus-lg'></i> Nuevo préstamo"; // Restaura el título
            //modalForm.reset(); // Limpia todos los inputs
            //modalForm.classList.remove('was-validated'); // Quita los checks verdes/rojos
            //modalForm.querySelector('#usuarioId').value = ''; // Limpia el ID oculto


        });

    });
</script>
<jsp:include page="components/footer.jsp" />
