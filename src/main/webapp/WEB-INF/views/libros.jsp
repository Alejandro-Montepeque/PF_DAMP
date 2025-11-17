<%-- 
    Document   : catalogoLibros
    Created on : 7 nov 2025, 6:25:10 p. m.
    Author     : LuisElias
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    request.setAttribute("activePage", "libros");
%>

<jsp:include page="components/header.jsp" />
<jsp:include page="components/sidebar.jsp" />

<div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary"><i class="bi bi-book me-2"></i> Catálogo de Libros</h2>
        <button class="btn btn-success" id="btnNuevoLibro" data-bs-toggle="modal" data-bs-target="#modalLibro">
            <i class="bi bi-plus-lg"></i> Nuevo libro
        </button>
    </div>

    <!-- Filtros -->
    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/LibrosServlet">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Género</label>
                        <select id="filtroGenero" name="filtroGenero" class="form-select">
                            <!-- opciones dinámicas -->
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Buscar por título o autor</label>
                        <input id="busqueda" name="busqueda" type="text" class="form-control" 
                               placeholder="Ej: García Márquez..." 
                               value="${busqueda != null ? busqueda : ''}">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> Buscar
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Cards de libros -->
    <div class="row" id="contenedorLibros">
        <c:forEach var="libro" items="${listaLibros}">
            <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                <div class="card shadow-sm h-100"
                    data-id="${libro.idLibro}"
                    data-titulo="${libro.titulo}"
                    data-idioma="${libro.idioma}"
                    data-publicacion="${libro.anioPublicacion}"
                    data-isbn="${libro.isbn}"
                    data-paginas="${libro.numPaginas}"
                    data-disponibles="${libro.cantDisponibles}"
                    data-fecha="${libro.fechaAdquisicion}"
                    data-genero="${libro.idGenero.idGenero}"
                    data-nivel="${libro.idNivelEducativo.idNivel}"
                    data-imagen="${libro.imagenPortada}"
                    data-activo="${libro.activo ? 'Activo' : 'Inactivo'}"
                    data-proveedor="${libro.idProveedor != null ? libro.idProveedor.idProveedor : ''}"
                    data-autor="${libro.autor != null ? libro.autor : ''}"
                    data-ubicacion="${libro.ubicacionFisica != null ? libro.ubicacionFisica : ''}"
                    >
                   
                    <img src="${pageContext.request.contextPath}/images/${libro.imagenPortada}"
                        class="card-img-top"
                        alt="${libro.titulo}"
                        style="height: 280px; object-fit: contain;">

                    <div class="card-body">
                        <h5 class="card-title">${libro.titulo}</h5>
                        <p class="small text-secondary">
                            ${libro.idProveedor != null ? libro.idProveedor.nombre : 'Sin proveedor'}
                            • ${libro.anioPublicacion}
                        </p>
                        <span class="badge ${libro.cantDisponibles > 0 ? 'bg-success' : 'bg-warning text-dark'}">
                            ${libro.cantDisponibles > 0 ? 'Disponible' : 'En préstamo'}
                        </span>
                    </div>
                    
                    <div class="card-footer bg-white text-end">
                        <button class="btn btn-sm btn-outline-success me-1 btn-editar" title="Editar" 
                                data-bs-toggle="modal" data-bs-target="#modalLibro">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <!--
                        <button class="btn btn-sm btn-outline-danger" title="Eliminar"
                                onclick="confirmarEliminar(${libro.idLibro})">
                            <i class="bi bi-trash"></i>
                        </button>
                        -->
                        
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty listaLibros}">
        <div class="alert alert-info">
            <i class="bi bi-info-circle me-2"></i>No hay libros disponibles.
        </div>
    </c:if>
</div>

<!-- Modal Agregar/Editar Libro -->
<div class="modal fade" id="modalLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="tituloModalLibro">
                    <i class="bi bi-book me-2"></i> Registrar nuevo libro
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formLibro" method="post" 
                    action="${pageContext.request.contextPath}/LibrosServlet" 
                    class="needs-validation" enctype="multipart/form-data" novalidate>
                    
                    <input type="hidden" id="indiceLibro" name="libroId">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Título</label>
                            <input type="text" class="form-control" id="tituloLibro" name="titulo" required>
                            <div class="invalid-feedback">Ingrese el título del libro.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Autor(es)</label>
                            <input type="text" class="form-control" id="autorLibro" name="autor" required>
                            <div class="invalid-feedback">Ingrese el autor.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Año de publicación</label>
                            <input type="number" class="form-control" id="anioLibro" 
                                   min="1500" max="2100" name="anioPublicacion" required>
                            <div class="invalid-feedback">Ingrese un año válido.</div>
                        </div>
                       
                        <div class="col-md-6">
                            <label class="form-label">Género/Categoría</label>
                            <select class="form-select" id="generoLibro" name="idGenero" required>
                                <option value="">Cargando géneros...</option>
                            </select>
                            <div class="invalid-feedback">Seleccione un género o categoría.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Idioma</label>
                            <select class="form-select" id="idiomaLibro" name="idioma" required>
                                <option value="">Seleccione un idioma</option>
                                <option value="Español">Español</option>
                                <option value="Inglés">Inglés</option>
                                <option value="Francés">Francés</option>
                                <option value="Alemán">Alemán</option>
                                <option value="Italiano">Italiano</option>
                                <option value="Portugués">Portugués</option>
                                <option value="Chino">Chino</option>
                                <option value="Japonés">Japonés</option>
                                <option value="Ruso">Ruso</option>
                                <option value="Árabe">Árabe</option>
                            </select>
                            <div class="invalid-feedback">Seleccione el idioma del libro.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">ISBN</label>
                            <input type="text" class="form-control" id="isbnLibro" name="isbn" maxlength="13" required>
                            <div class="invalid-feedback">Ingrese el número ISBN.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Páginas</label>
                            <input type="number" class="form-control" id="paginasLibro" 
                                   name="numPaginas" required min="1">
                            <div class="invalid-feedback">Ingrese el número de páginas.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Copias disponibles</label>
                            <input type="number" class="form-control" id="copiasLibro" 
                                   name="cantDisponibles" required min="1">
                            <div class="invalid-feedback">Ingrese el número de copias disponibles.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Ubicación física</label>
                            <input type="text" class="form-control" id="ubicacionLibro" name="ubicacionFisica" 
                                   placeholder="Ej: Estante A3" required>
                            <div class="invalid-feedback">Ingrese la ubicación física.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Nivel educativo</label>
                            <select class="form-select" id="nivelLibro" name="idNivelEducativo" required>
                                <option value="">Cargando niveles educativos...</option>
                            </select>
                            <div class="invalid-feedback">Seleccione un nivel educativo.</div>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Proveedor</label>
                            <select id="proveedor" class="form-select" name="idProveedor" required>
                                <option value="">Cargando proveedores...</option>
                            </select>
                            <div class="invalid-feedback">Seleccione el proveedor.</div>
                        </div>
                        <!-- 
                        <div class="col-md-6">
                            <label class="form-label">Disponibilidad</label>
                            <select id="disponibleLibro" class="form-select" required>
                                <option value="true">Disponible para préstamo</option>
                                <option value="false">Solo consulta en sala</option>
                            </select>
                            <div class="invalid-feedback">Seleccione la disponibilidad.</div>
                        </div>
                        -->

                        <div class="col-md-6">
                            <label class="form-label">Fecha de adquisición</label>
                            <input type="date" class="form-control" id="fechaDisponibleLibro" 
                                   name="fechaAdquisicion">
                        </div>

                        <div class="col-12">
                            <label for="imgPortada" class="form-label">Imagen de portada</label>
                            <input class="form-control" type="file" id="imgPortada" 
                                   accept=".jpg, .jpeg, .png" name="imagenPortada">
                        </div>
                        
                        <div class="col-12" id="bloquePreview" style="display: none;">
                            <label class="form-label">Imagen actual</label>
                            <img id="previewImagen" src="" alt="Vista previa"
                                 style="max-height: 180px; object-fit: contain;"
                                 class="border rounded p-2 d-block">
                        </div>
                        
                        <div class="col-md-6 d-flex align-items-center">
                            <div class="form-check form-switch mt-3">
                                <input class="form-check-input" type="checkbox" id="activo" name="activo" checked>
                                <label class="form-check-label" for="activo">Libro Activo</label>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Eliminar -->
<div class="modal fade" id="modalEliminarLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="bi bi-trash"></i> Confirmar eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                ¿Seguro que deseas eliminar este libro? Esta acción no se puede deshacer.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger" id="btnConfirmarEliminar">Eliminar</button>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("formLibro");
    const modalHeader = document.querySelector("#modalLibro .modal-header");
    const tituloModal = document.getElementById("tituloModalLibro");
    const btnNuevo = document.getElementById("btnNuevoLibro");
    const contextPath = "<%= request.getContextPath() %>";
    let idAEliminar = null;

    const filtroGeneroSeleccionado = "${filtroGenero}";

    // Cargar catálogos
    cargarGenerosEnFiltro();
    cargarGeneros();
    cargarNiveles();
    cargarProveedores();

    // Función para cargar géneros
    function cargarGeneros() {
        fetch(contextPath + "/api/generos")
            .then(response => response.json())
            .then(generos => {
                const selectGenero = document.getElementById("generoLibro");
                selectGenero.innerHTML = '<option value="">Seleccione...</option>';
                
                generos.forEach(genero => {
                    const option = document.createElement("option");
                    option.value = genero.id_genero;
                    option.textContent = genero.nombre;
                    selectGenero.appendChild(option);
                });
            })
            .catch(error => {
                console.error("Error cargando géneros:", error);
                document.getElementById("generoLibro").innerHTML = 
                    '<option value="">Error al cargar géneros</option>';
            });
    }
    
    // Función para cargar niveles
    function cargarNiveles() {
        fetch(contextPath + "/api/niveles")
            .then(response => response.json())
            .then(niveles => {
                const selectNivel = document.getElementById("nivelLibro");
                selectNivel.innerHTML = '<option value="">Seleccione...</option>';
                
                niveles.forEach(nivel => {
                    const option = document.createElement("option");
                    option.value = nivel.id_nivel;
                    option.textContent = nivel.nombre;
                    selectNivel.appendChild(option);
                });
            })
            .catch(error => {
                console.error("Error cargando niveles", error);
                document.getElementById("nivelLibro").innerHTML = 
                    '<option value="">Error al cargar niveles</option>';
            });
    }
    
    // Función para cargar proveedores
    function cargarProveedores() {
        fetch(contextPath + "/api/proveedores")
            .then(response => response.json())
            .then(proveedores => {
                const selectProveedor = document.getElementById("proveedor");
                selectProveedor.innerHTML = '<option value="">Seleccione...</option>';

                proveedores.forEach(proveedor => {
                    const option = document.createElement("option");
                    option.value = proveedor.id_proveedor;
                    option.textContent = proveedor.nombre;
                    selectProveedor.appendChild(option);
                });
            })
            .catch(error => {
                console.error("Error cargando proveedores:", error);
                document.getElementById("proveedor").innerHTML = 
                    '<option value="">Error al cargar proveedores</option>';
            });
    }
    
    // Función para cargar generos en filtro inicial
    function cargarGenerosEnFiltro() {
        fetch(contextPath + "/api/generos")
            .then(response => response.json())
            .then(generos => {
                const selectGenero = document.getElementById("filtroGenero");
                
                // Mantener "Todos" como primera opción
                const option = document.createElement("option");
                option.value = "todos";
                option.textContent = "Todos";
                selectGenero.appendChild(option);
               
                generos.forEach(genero => {
                    const option = document.createElement("option");
                    option.value = genero.id_genero;
                    option.textContent = genero.nombre;
                    selectGenero.appendChild(option);
                });
                
                // Restaurar valor seleccionado
                selectGenero.value = filtroGeneroSeleccionado || "todos";
            })
            .catch(error => {
                console.error("Error cargando géneros para filtro:", error);
            });
    }

    // Nuevo libro
    btnNuevo.addEventListener("click", () => {
        form.reset();
        form.classList.remove("was-validated");
        document.getElementById("indiceLibro").value = "";
        document.getElementById("bloquePreview").style.display = "none";
        
        tituloModal.innerHTML = "<i class='bi bi-book me-2'></i> Registrar nuevo libro";
        modalHeader.classList.remove("bg-warning", "text-dark");
        modalHeader.classList.add("bg-success", "text-white");
    });

    // Validación del formulario
    form.addEventListener("submit", (event) => {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
            form.classList.add("was-validated");
        }
    });

    // Editar libro
    document.querySelectorAll('.btn-editar').forEach(btn => {
        btn.addEventListener('click', function () {
            const card = this.closest('.card');
            const data = card.dataset;
            
            form.classList.remove("was-validated");
            modalHeader.classList.remove("bg-success", "text-white");
            modalHeader.classList.add("bg-warning", "text-dark");
            tituloModal.innerHTML = "<i class='bi bi-pencil me-2'></i> Editar libro";
            
            document.getElementById("indiceLibro").value = data.id;
            document.getElementById("tituloLibro").value = data.titulo;
            document.getElementById("anioLibro").value = data.publicacion;
            document.getElementById("idiomaLibro").value = data.idioma;
            document.getElementById("isbnLibro").value = data.isbn;
            document.getElementById("paginasLibro").value = data.paginas;
            document.getElementById("copiasLibro").value = data.disponibles;
            document.getElementById("fechaDisponibleLibro").value = data.fecha;
            document.getElementById("nivelLibro").value = data.nivel;
            document.getElementById("generoLibro").value = data.genero;
            document.getElementById("activo").checked = (data.activo == 'Activo');
            document.getElementById("proveedor").value = data.proveedor;
            document.getElementById("autorLibro").value = data.autor || '';
            document.getElementById("ubicacionLibro").value = data.ubicacion || '';
            
            // Mostrar imagen actual si existe
            if (data.imagen && data.imagen !== "null" && data.imagen !== "") {
                document.getElementById("bloquePreview").style.display = "block";
                document.getElementById("previewImagen").src = contextPath + "/images/" + data.imagen;
            } else {
                document.getElementById("bloquePreview").style.display = "none";
            }
        });
    });

    // Eliminar libro
    window.confirmarEliminar = (idLibro) => {
        idAEliminar = idLibro;
        new bootstrap.Modal(document.getElementById("modalEliminarLibro")).show();
    };
    
    document.getElementById("btnConfirmarEliminar").addEventListener("click", () => {
        if (idAEliminar !== null) {
            fetch(contextPath + "/LibrosServlet?id=" + idAEliminar, { method: "DELETE" })
                .then(response => {
                    if (response.ok) {
                        bootstrap.Modal.getInstance(document.getElementById("modalEliminarLibro")).hide();
                        window.location.reload();
                    } else {
                        alert("Error al eliminar el libro");
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("Error al eliminar el libro");
                });
        }
    });
});
</script>

<jsp:include page="components/footer.jsp" />