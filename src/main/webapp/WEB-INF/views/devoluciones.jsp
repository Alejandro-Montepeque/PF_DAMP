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
    String rol = (String) session.getAttribute("rol");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-arrow-repeat me-2"></i> Gestión de Devoluciones</h2>
        <% if ("ADMIN".equals(rol)) {
        %>
        <button class="btn btn-success" id="btnNuevo" data-bs-toggle="modal" data-bs-target="#modalDevolucion">
            <i class="bi bi-plus-lg"></i> Registrar devolución
        </button>
        <%
            }
        %>
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
            <div class="table-responsive">
            <table id="tablaDevoluciones" class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Usuario</th>
                        <th>Libro</th>
                        <th>Fecha préstamo</th>
                        <th>Fecha devolución</th>
                        <th>Estado</th>
                        <th>Observaciones</th>
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
                        <td>Ana López</td>
                        <td>Introducción a Java</td>
                        <td>2025-10-25</td>
                        <td>2025-11-05</td>
                        <td><span class="badge bg-success">Entregado</span></td>
                        <td>Sin observaciones</td>
                        <% if ("ADMIN".equals(rol)) {
                        %>
                        <td>
                            <button class="btn btn-sm btn-outline-primary btn-editar" data-bs-toggle="modal" data-bs-target="#modalDevolucion"><i class="bi bi-pencil"></i> Editar</button>                       
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
<script>
    // Espera a que la página esté completamente cargada
    document.addEventListener('DOMContentLoaded', function () {

        //const modalForm = document.getElementById('usuarioForm');
        const modalTitle = document.getElementById('modalDevolucionLabel');
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
                modalTitle.innerHTML = "<i class='bi bi-pencil-square'></i> Editar Devolucion"; // Cambia el título


            });
        });

        // 2. Escucha el clic en el botón "Nuevo Usuario"
        document.getElementById('btnNuevo').addEventListener('click', function () {
            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");

            // --- Limpia el formulario ---
            modalTitle.innerHTML = "<i class='bi bi-plus-lg'></i> Registrar Devolucion"; // Restaura el título
            //modalForm.reset(); // Limpia todos los inputs
            //modalForm.classList.remove('was-validated'); // Quita los checks verdes/rojos
            //modalForm.querySelector('#usuarioId').value = ''; // Limpia el ID oculto


        });

    });
</script>
<jsp:include page="components/footer.jsp" />


