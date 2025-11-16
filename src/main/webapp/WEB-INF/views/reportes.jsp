<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    request.setAttribute("activePage", "reportes");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<script>
    const BASE_URL = "${pageContext.request.contextPath}";
</script>

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">

    <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
        <h2 class="fw-bold text-primary"><i class="bi bi-file-earmark-text me-2"></i> Reportes del Sistema</h2>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h5 class="fw-semibold mb-3"><i class="bi bi-funnel me-2"></i> Generar Reporte</h5>

            <form id="formReportes" class="row g-3" onsubmit="return false;">
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Tipo de Reporte</label>
                    <select id="tipoReporte" name="tipoReporte" class="form-select">
                        <option value="libros" selected>Catálogo de Libros</option>
                        <option value="proveedores">Proveedores / Editoriales</option>
                        <option value="usuarios">Usuarios Registrados</option>
                    </select>
                </div>

                <div class="col-md-12 d-flex justify-content-end mt-3">
                    <button type="button" id="btnGenerarPDF" class="btn btn-danger me-2">
                        <i class="bi bi-file-earmark-pdf"></i> Exportar PDF
                    </button>
                    <button type="button" id="btnLimpiar" class="btn btn-outline-secondary">
                        <i class="bi bi-x-circle"></i> Limpiar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="alert alert-info">
        <i class="bi bi-info-circle me-2"></i>
        Seleccione el tipo de reporte y haga clic en <strong>Exportar PDF</strong>. El archivo se descargará automáticamente.
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const selectTipo = document.getElementById("tipoReporte");
    const btnPDF = document.getElementById("btnGenerarPDF");
    const btnLimpiar = document.getElementById("btnLimpiar");

    btnPDF.addEventListener("click", () => {
        const tipo = selectTipo.value;
        if (!tipo) {
            alert("Seleccione un tipo de reporte.");
            return;
        }

        const url = BASE_URL + "/ReportesServlet?tipo=" + encodeURIComponent(tipo);
        window.location.href = url;
    });

    btnLimpiar.addEventListener("click", () => {
        selectTipo.value = "libros";
    });
});
</script>

<jsp:include page="components/footer.jsp" />
