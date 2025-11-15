<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    request.setAttribute("activePage", "proveedores");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />


<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-building me-2"></i> Gestión de Proveedores</h2>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#proveedorModal" id="btnNuevo">
            <i class="bi bi-plus-lg"></i> Nuevo proveedor
        </button>
    </div>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form class="row g-3" method="GET" action="${pageContext.request.contextPath}/ProveedoresServlet">
                
                <input type="hidden" name="accion" value="listar">
                
                <div class="col-md-8">
                    <label class="form-label">Buscar por nombre o tipo</label>
                    <input type="text" class="form-control" id="filtroTexto" name="filtroTexto" 
                           placeholder="Ej: Santillana, Editorial XYZ..." value="${filtroTexto}">
                </div>
                <div class="col-md-2 d-grid">
                     <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100" id="btnBuscar">
                        <i class="bi bi-search"></i> Buscar
                    </button>
                </div>
                 <div class="col-md-2 d-grid">
                     <label class="form-label">&nbsp;</label>
                    <a href="${pageContext.request.contextPath}/ProveedoresServlet" class="btn btn-outline-secondary w-100">Refrescar</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped align-middle text-center" id="tablaProveedores">
                    <thead class="table-primary">
                        <tr>
                            <th>#</th>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Dirección</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="prov" items="${listaProveedores}" varStatus="loop">
                            <tr 
                                data-id="${prov.idProveedor}"
                                data-nombre="${prov.nombre}"
                                data-tipo="${prov.tipo}"
                                data-telefono="${prov.telefono}"
                                data-email="${prov.email}"
                                data-direccion="${prov.direccion}">
                                
                                <td>${loop.count}</td>
                                <td>${prov.nombre}</td>
                                <td>${prov.tipo}</td>
                                <td>${prov.telefono}</td>
                                <td>${prov.email}</td>
                                <td>${prov.direccion}</td>
                                <td>
                                    
                                    <button class="btn btn-sm btn-outline-primary btn-editar" 
                                            data-bs-toggle="modal" data-bs-target="#proveedorModal"
                                            title="Editar">
                                        <i class="bi bi-pencil"></i>
                                    </button>                                  
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaProveedores}">
                            <tr>
                                <td colspan="7" class="text-center text-muted">No se encontraron proveedores.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="proveedorModal" tabindex="-1" aria-labelledby="proveedorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        
        <form id="proveedorForm" 
              method="POST" 
              action="${pageContext.request.contextPath}/ProveedoresServlet" 
              class="modal-content needs-validation" novalidate>
            
            <div class="modal-header" id="modalHeader">
                <h5 class="modal-title" id="proveedorModalLabel"><i class="bi bi-plus-lg me-2"></i> Nuevo Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            
            <div class="modal-body">
                <input type="hidden" name="accion" value="guardar">
                <input type="hidden" id="proveedorId" name="proveedorId">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nombre</label>
                        <input type="text" id="nombre" name="nombre" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tipo</label>
                        <select id="tipo" name="tipo" class="form-select" required>
                            <option value="">Elegir...</option>
                            <option>Editorial</option>
                            <option>Imprenta</option>
                            <option>Distribuidor</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Teléfono</label>
                        <input type="text" id="telefono" name="telefono" class="form-control" placeholder="0000-0000">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Correo electrónico</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="ejemplo@correo.com">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Dirección</label>
                        <input type="text" id="direccion" name="direccion" class="form-control" placeholder="Dirección completa">
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

<jsp:include page="components/footer.jsp" />

<script>
    <c:if test="${not empty mensajeExito}">
        mostrarAlertaExito("${mensajeExito}");
    </c:if>
    <c:if test="${not empty mensajeError}">
        mostrarAlertaError("${mensajeError}");
    </c:if>
</script>

<script>
    
    document.addEventListener('DOMContentLoaded', function () {
    
        const modalEl = document.getElementById('proveedorModal');
        const modalForm = document.getElementById('proveedorForm');
        const modalTitle = document.getElementById('proveedorModalLabel');
        const modalHeader = document.getElementById('modalHeader');
        const modalBtnGuardar = document.getElementById('btnGuardar');

        document.querySelectorAll('.btn-editar').forEach(btn => {
            btn.addEventListener('click', function () {
                
                const row = this.closest('tr');
                const data = row.dataset;

                modalTitle.innerHTML = '<i class="bi bi-pencil me-2"></i> Editar Proveedor';
                modalHeader.className = 'modal-header bg-primary text-white';
                modalBtnGuardar.className = 'btn btn-primary';
                
                modalForm.querySelector('#proveedorId').value = data.id;
                modalForm.querySelector('#nombre').value = data.nombre;
                modalForm.querySelector('#tipo').value = data.tipo;
                modalForm.querySelector('#telefono').value = data.telefono;
                modalForm.querySelector('#email').value = data.email;
                modalForm.querySelector('#direccion').value = data.direccion;
            });
        });

        document.getElementById('btnNuevo').addEventListener('click', function () {
            
 
            modalTitle.innerHTML = '<i class="bi bi-plus-lg me-2"></i> Nuevo Proveedor';
            modalHeader.className = 'modal-header bg-success text-white';
            modalBtnGuardar.className = 'btn btn-success';
            
            modalForm.reset();
            modalForm.querySelector('#proveedorId').value = '';
            modalForm.classList.remove('was-validated');
        });
    
    });
</script>