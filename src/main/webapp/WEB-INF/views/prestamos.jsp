<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    request.setAttribute("activePage", "prestamos");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<script>
    const emails = [
    <c:forEach var="e" items="${emails}">
        "${e}",
    </c:forEach>
    ];

    const titulos = [
    <c:forEach var="t" items="${titulos}">
        "${t}",
    </c:forEach>
    ];
</script>

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary">
            <i class="bi bi-book"></i> Gestión de Préstamos
        </h2>
        <button class="btn btn-success" id="btnNuevo">
            <i class="bi bi-plus-lg"></i> Nuevo préstamo
        </button>
    </div>

    <div class="card mb-3">
        <div class="card-body">
            <form id="formBuscar" onsubmit="return false;" class="row g-2 align-items-end">
                <div class="col-md-8">
                    <label class="form-label">Buscar por usuario o libro</label>
                    <input id="filtroGlobal" type="text" class="form-control" placeholder="Ej: Juan Pérez o El Quijote...">
                </div>
                <div class="col-md-2">
                    <button id="btnBuscar" class="btn btn-primary w-100"><i class="bi bi-search"></i> Buscar</button>
                </div>
                <div class="col-md-2">
                    <button id="btnRefrescar" class="btn btn-outline-secondary w-100"><i class="bi bi-arrow-clockwise"></i> Refrescar</button>
                </div>
            </form>
        </div>
    </div>
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table id="tablaPrestamos" class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Usuario (Email)</th>
                            <th>Libro</th>
                            <th>Fecha préstamo</th>
                            <th>Fecha estimada</th>
                            <th>Fecha real</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:forEach var="p" items="${listaPrestamos}">
                            <tr>
                                <td>${p.idPrestamo}</td>
                                <td>${p.idUsuario.email}</td>
                                <td>${p.idLibro.titulo}</td>

                                <td><fmt:formatDate value="${p.fechaPrestamo}" pattern="yyyy-MM-dd" /></td>
                                <td><fmt:formatDate value="${p.fechaEntregaEstimada}" pattern="yyyy-MM-dd" /></td>

                                <td>
                                    <c:choose>
                                        <c:when test="${p.fechaEntregaReal != null}">
                                            <fmt:formatDate value="${p.fechaEntregaReal}" pattern="yyyy-MM-dd" />
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>${p.estado}</td>

                                <td>
                                    <button class="btn btn-primary btn-sm btnEditar"
                                            data-id="${p.idPrestamo}"
                                            data-email="${p.idUsuario.email}"
                                            data-titulo="${p.idLibro.titulo}"
                                            data-fp="<fmt:formatDate value='${p.fechaPrestamo}' pattern='yyyy-MM-dd'/>"
                                            data-fe="<fmt:formatDate value='${p.fechaEntregaEstimada}' pattern='yyyy-MM-dd'/>"
                                            data-fr="<fmt:formatDate value='${p.fechaEntregaReal}' pattern='yyyy-MM-dd'/>"
                                            data-obs="${p.observaciones}"
                                            data-estado="${p.estado}">
                                        <i class="bi bi-pencil"></i> Editar
                                    </button>
                                </td>

                            </tr>
                        </c:forEach>

                        <c:if test="${empty listaPrestamos}">
                            <tr>
                                <td colspan="8" class="text-center text-muted">No hay préstamos registrados.</td>
                            </tr>
                        </c:if>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalPrestamo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-success text-white">
                <h5 id="modalTitle" class="modal-title">Nuevo préstamo</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <form id="formPrestamo" method="post" action="${pageContext.request.contextPath}/PrestamosServlet">

                <div class="modal-body">
                    <input type="hidden" name="idPrestamo" id="idPrestamo">

                    <!-- EMAIL -->
                    <div class="col-md-12 mb-3 position-relative">
                        <label class="form-label">Usuario (email)</label>
                        <input type="hidden" name="emailUsuario" id="emailUsuario">
                        <input type="text" id="buscarUsuario" class="form-control" placeholder="Buscar email..." autocomplete="off">
                        <div id="resultadosUsuario" class="list-group mt-1 position-absolute w-100" style="z-index:1000;"></div>
                    </div>

                    <!-- LIBRO -->
                    <div class="col-md-12 mb-3 position-relative">
                        <label class="form-label">Libro</label>
                        <input type="hidden" name="tituloLibro" id="tituloLibro">
                        <input type="text" id="buscarLibro" class="form-control" placeholder="Buscar libro..." autocomplete="off">
                        <div id="resultadosLibro" class="list-group mt-1 position-absolute w-100" style="z-index:1000;"></div>
                    </div>

                    <!-- FECHAS -->
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Fecha préstamo</label>
                            <input type="date" id="fechaPrestamo" name="fechaPrestamo" class="form-control" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Fecha entrega estimada</label>
                            <input type="date" id="fechaEstimada" name="fechaEstimada" class="form-control" required>
                        </div>

                        <div class="col-md-6 d-none" id="boxFR">
                            <label class="form-label">Fecha entrega real</label>
                            <input type="date" id="fechaReal" name="fechaReal" class="form-control">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Estado</label>
                            <select id="estado" name="estado" class="form-select">
                                <option value="Pendiente">Pendiente</option>
                                <option value="Entregado">Entregado</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-12 mt-3 d-none" id="boxObs">
                        <label class="form-label">Observaciones</label>
                        <textarea id="observaciones" name="observaciones" class="form-control" rows="3"></textarea>
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button class="btn btn-primary">Guardar</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
    <c:if test="${not empty mensajeExito}">
    mostrarAlertaExito('<c:out value="${mensajeExito}"/>');
    </c:if>
    <c:if test="${not empty mensajeError}">
    mostrarAlertaError('<c:out value="${mensajeError}"/>');
    </c:if>
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {

        const modal = new bootstrap.Modal(document.getElementById("modalPrestamo"));

        const toDate = (d) => {
            const y = d.getFullYear();
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const da = String(d.getDate()).padStart(2, '0');
            return `${y}-${m}-${da}`;
                    };


                    document.getElementById("btnNuevo").onclick = () => {
                        document.getElementById("modalTitle").innerText = "Nuevo préstamo";
                        document.getElementById("formPrestamo").reset();

                        document.getElementById("idPrestamo").value = "";

                        // Fechas por defecto
                        const hoy = new Date();
                        document.getElementById("fechaPrestamo").value = toDate(hoy);

                        const estimada = new Date();
                        estimada.setDate(estimada.getDate() + 14);
                        document.getElementById("fechaEstimada").value = toDate(estimada);

                        document.getElementById("boxFR").classList.add("d-none");
                        document.getElementById("boxObs").classList.add("d-none");

                        modal.show();
                    };

                    const inpEmail = document.getElementById("buscarUsuario");
                    const resEmail = document.getElementById("resultadosUsuario");

                    inpEmail.addEventListener("input", () => {
                        const q = inpEmail.value.toLowerCase();
                        resEmail.innerHTML = "";

                        if (!q)
                            return;

                        emails.filter(e => e.toLowerCase().includes(q))
                                .slice(0, 7)
                                .forEach(e => {
                                    const item = document.createElement("button");
                                    item.type = "button";
                                    item.className = "list-group-item list-group-item-action";
                                    item.textContent = e;
                                    item.onclick = () => {
                                        inpEmail.value = e;
                                        document.getElementById("emailUsuario").value = e;
                                        resEmail.innerHTML = "";
                                    };
                                    resEmail.appendChild(item);
                                });
                    });

                    const inpLibro = document.getElementById("buscarLibro");
                    const resLibro = document.getElementById("resultadosLibro");

                    inpLibro.addEventListener("input", () => {
                        const q = inpLibro.value.toLowerCase();
                        resLibro.innerHTML = "";

                        if (!q)
                            return;

                        titulos.filter(t => t.toLowerCase().includes(q))
                                .slice(0, 7)
                                .forEach(t => {
                                    const item = document.createElement("button");
                                    item.type = "button";
                                    item.className = "list-group-item list-group-item-action";
                                    item.textContent = t;
                                    item.onclick = () => {
                                        inpLibro.value = t;
                                        document.getElementById("tituloLibro").value = t;
                                        resLibro.innerHTML = "";
                                    };
                                    resLibro.appendChild(item);
                                });
                    });

                    document.querySelectorAll(".btnEditar").forEach(btn => {
                        btn.addEventListener("click", () => {

                            document.getElementById("modalTitle").innerText = "Editar préstamo";
                            document.getElementById("idPrestamo").value = btn.dataset.id;

                            document.getElementById("buscarUsuario").value = btn.dataset.email;
                            document.getElementById("emailUsuario").value = btn.dataset.email;

                            document.getElementById("buscarLibro").value = btn.dataset.titulo;
                            document.getElementById("tituloLibro").value = btn.dataset.titulo;

                            document.getElementById("fechaPrestamo").value = btn.dataset.fp;
                            document.getElementById("fechaEstimada").value = btn.dataset.fe;

                            document.getElementById("boxFR").classList.remove("d-none");
                            document.getElementById("fechaReal").value = (btn.dataset.fr && btn.dataset.fr !== "null")
                                    ? btn.dataset.fr
                                    : "";

                            document.getElementById("estado").value = btn.dataset.estado;

                            document.getElementById("boxObs").classList.remove("d-none");
                            document.getElementById("observaciones").value =
                                    (btn.dataset.obs && btn.dataset.obs !== "null")
                                    ? btn.dataset.obs
                                    : "";
                            modal.show();
                        });
                    });

                    document.getElementById("formPrestamo").addEventListener("submit", (e) => {

                        if (!document.getElementById("emailUsuario").value) {
                            mostrarAlertaError("Debe seleccionar un usuario válido.");
                            e.preventDefault();
                            return false;
                        }

                        if (!document.getElementById("tituloLibro").value) {
                            mostrarAlertaError("Debe seleccionar un libro válido.");
                            e.preventDefault();
                            return false;
                        }
                    });

                    document.getElementById("btnBuscar").onclick = () => {
                        const q = document.getElementById("filtroGlobal").value.toLowerCase();
                        document.querySelectorAll("#tablaPrestamos tbody tr").forEach(tr => {
                            tr.style.display = tr.innerText.toLowerCase().includes(q) ? "" : "none";
                        });
                    };

                    document.getElementById("btnRefrescar").onclick = () => location.reload();

                });
</script>

<jsp:include page="components/footer.jsp" />
