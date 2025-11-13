<%-- 
    Document   : catalogoLibros
    Created on : 7 nov 2025, 6:25:10 p. m.
    Author     : LuisElias
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Género</label>
                    <select id="filtroGenero" class="form-select">
                        <option value="todos" selected>Todos</option>
                        <option>Infantil</option>
                        <option>Juvenil</option>
                        <option>Universitario</option>
                        <option>General</option>
                        <option>Ficción</option>
                        <option>Educativo</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Buscar por título o autor</label>
                    <input id="busqueda" type="text" class="form-control" placeholder="Ej: García Márquez...">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button class="btn btn-primary w-100" id="btnBuscar"><i class="bi bi-search"></i> Buscar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Cards de libros -->
    <div class="row" id="contenedorLibros"></div>
</div>

<!-- Modal Agregar/Editar Libro -->
<div class="modal fade" id="modalLibro" tabindex="-1" aria-labelledby="modalLibroLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="tituloModalLibro">
                    <i class="bi bi-book me-2"></i> Registrar nuevo libro
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formLibro" class="needs-validation" novalidate>
                    <input type="hidden" id="indiceLibro">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Título</label>
                            <input type="text" class="form-control" id="tituloLibro" required>
                            <div class="invalid-feedback">Ingrese el título del libro.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Autor(es)</label>
                            <input type="text" class="form-control" id="autorLibro" required>
                            <div class="invalid-feedback">Ingrese el autor o autores.</div>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Año de publicación</label>
                            <input type="number" class="form-control" id="anioLibro" min="1500" max="2100" required>
                            <div class="invalid-feedback">Ingrese un año válido.</div>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Género/Categoría</label>
                            <select class="form-select" id="generoLibro" required>
                                <option value="">Seleccione...</option>
                                <option>Infantil</option>
                                <option>Juvenil</option>
                                <option>Universitario</option>
                                <option>General</option>
                                <option>Educativo</option>
                                <option>Ficción</option>
                            </select>
                            <div class="invalid-feedback">Seleccione un género o categoría.</div>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Idioma</label>
                            <select class="form-select" id="idiomaLibro" required>
                                <option value="" select>Seleccione un idioma</option>
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


                        <div class="col-md-3">
                            <label class="form-label">ISBN</label>
                            <input type="text" class="form-control" id="isbnLibro" required>
                            <div class="invalid-feedback">Ingrese el número ISBN.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Editorial</label>
                            <select id="editorialLibro" class="form-select" required>
                                <option value="" select>Seleccione una editorial</option>
                                <option>Reynal & Hitchcock</option>
                                <option>Penguin Random House</option>
                                <option>Editorial Planeta</option>
                            </select>
                            <div class="invalid-feedback">Seleccione la editorial.</div>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Páginas</label>
                            <input type="number" class="form-control" id="paginasLibro" required min="1">
                            <div class="invalid-feedback">Ingrese el número de páginas.</div>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">Copias disponibles</label>
                            <input type="number" class="form-control" id="copiasLibro" required min="1">
                            <div class="invalid-feedback">Ingrese el número de copias disponibles.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Ubicación física</label>
                            <input type="text" class="form-control" id="ubicacionLibro" placeholder="Ej: Estante A3" required>
                            <div class="invalid-feedback">Ingrese la ubicación física.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Nivel educativo recomendado</label>
                            <select id="nivelLibro" class="form-select" required>
                                <option value="">Seleccione...</option>
                                <option>Infantil</option>
                                <option>Juvenil</option>
                                <option>Universitario</option>
                                <option>General</option>
                            </select>
                            <div class="invalid-feedback">Seleccione el nivel educativo.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Disponibilidad</label>
                            <select id="disponibleLibro" class="form-select" required>
                                <option value="true">Disponible para préstamo</option>
                                <option value="false">Solo consulta en sala</option>
                            </select>
                            <div class="invalid-feedback">Seleccione la disponibilidad.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Fecha disponible (si está en préstamo)</label>
                            <input type="date" class="form-control" id="fechaDisponibleLibro">
                        </div>

                        <div class="mb-3">
                            <label for="formFile" class="form-label">Imagen de portada</label>
                            <input class="form-control" type="file" id="imgPortada" accept=".jpg, .jpeg, .png">
                        </div>
                    </div>

                    <div class="mt-4 text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success" id="btnGuardarLibro">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Modal Ver Libro -->
<div class="modal fade" id="modalVerLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title fw-bold">
                    <i class="bi bi-eye me-2"></i> Detalles del libro
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4" id="detalleLibro"></div>
        </div>
    </div>
</div>


<!-- Modal Eliminar -->
<div class="modal fade" id="modalEliminarLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="bi bi-trash"></i> Confirmar eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                ¿Seguro que deseas eliminar este libro?
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

        // --- REFERENCIAS ---
        const form = document.getElementById("formLibro");
        const modalHeader = document.querySelector("#modalLibro .modal-header");
        const tituloModal = document.getElementById("tituloModalLibro");
        const btnNuevo = document.getElementById("btnNuevoLibro");
        const contenedor = document.getElementById("contenedorLibros");

        let indiceAEliminar = null;
        let libros = [
            {
                titulo: "El Principito",
                autor: "Antoine de Saint-Exupéry",
                anio: 1943,
                genero: "Infantil",
                idioma: "Francés",
                editorial: "Reynal & Hitchcock",
                isbn: "978-0156012195",
                paginas: 96,
                copias: 3,
                ubicacion: "A1",
                nivel: "Infantil",
                disponible: true,
                fechaDisponible: "",
                portada: "https://m.media-amazon.com/images/I/71UwSHSZRnS.jpg"
            },
            {
                titulo: "Cien años de soledad",
                autor: "Gabriel García Márquez",
                anio: 1967,
                genero: "Ficción",
                idioma: "Español",
                editorial: "Sudamericana",
                isbn: "978-0307474728",
                paginas: 471,
                copias: 5,
                ubicacion: "B2",
                nivel: "General",
                disponible: false,
                fechaDisponible: "2025-11-25",
                portada: "https://librosusa.com/wp-content/uploads/2023/05/libro.jpg"
            }
        ];

        // --- RENDERIZAR LIBROS EN CARDS ---
        function renderLibros(lista) {
            contenedor.innerHTML = "";
            lista.forEach((libro, i) => {
                contenedor.innerHTML += `
                <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <img src="\${libro.portada}" class="card-img-top" alt="\${libro.titulo}" style="height: 280px; object-fit: contain;">
                        <div class="card-body">
                            <h5 class="card-title">\${libro.titulo}</h5>
                            <p class="text-muted mb-1">\${libro.autor}</p>
                            <p class="small text-secondary">\${libro.editorial} • \${libro.anio}</p>
                            <span class="badge \${libro.disponible ? 'bg-success' : 'bg-warning text-dark'}">
                                \${libro.disponible ? 'Disponible' : 'En préstamo'}
                            </span>
                        </div>
                        <div class="card-footer bg-white text-end">
                            <button class="btn btn-sm btn-outline-primary me-1" onclick="verLibro(\${i})"><i class="bi bi-eye"></i></button>
                            <button class="btn btn-sm btn-outline-warning me-1" onclick="editarLibro(\${i})"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-sm btn-outline-danger" onclick="confirmarEliminar(\${i})"><i class="bi bi-trash"></i></button>
                        </div>
                    </div>
                </div>`;
            });
        }

        renderLibros(libros);

        // --- NUEVO LIBRO ---
        btnNuevo.addEventListener("click", () => {
            form.reset();
            form.classList.remove("was-validated");
            document.getElementById("indiceLibro").value = "";

            tituloModal.innerHTML = "<i class='bi bi-book me-2'></i> Registrar nuevo libro";
            modalHeader.classList.remove("bg-warning", "text-dark");
            modalHeader.classList.add("bg-success", "text-white");
        });

        // --- GUARDAR LIBRO (con validación Bootstrap) ---
        form.addEventListener("submit", (event) => {
            event.preventDefault();
            event.stopPropagation();

            if (!form.checkValidity()) {
                form.classList.add("was-validated");
                return;
            }

            const nuevoLibro = {
                titulo: document.getElementById("tituloLibro").value,
                autor: document.getElementById("autorLibro").value,
                anio: document.getElementById("anioLibro").value,
                genero: document.getElementById("generoLibro").value,
                idioma: document.getElementById("idiomaLibro").value,
                editorial: document.getElementById("editorialLibro").value,
                isbn: document.getElementById("isbnLibro").value,
                paginas: document.getElementById("paginasLibro").value,
                copias: document.getElementById("copiasLibro").value,
                ubicacion: document.getElementById("ubicacionLibro").value,
                nivel: document.getElementById("nivelLibro").value,
                disponible: document.getElementById("disponibleLibro").value === "true",
                fechaDisponible: document.getElementById("fechaDisponibleLibro").value,
                portada: "https://via.placeholder.com/150x220.png?text=Sin+Portada"
            };

            const indice = document.getElementById("indiceLibro").value;
            if (indice === "") {
                libros.push(nuevoLibro);
            } else {
                libros[indice] = nuevoLibro;
            }

            renderLibros(libros);
            bootstrap.Modal.getInstance(document.getElementById("modalLibro")).hide();
            form.classList.remove("was-validated");
        });

        // --- VER LIBRO ---
        window.verLibro = (i) => {
            const l = libros[i];
            let detalle = `
            <div class="row">
                <div class="col-md-4 text-center mb-3">
                    <img src="\${l.portada}" alt="\${l.titulo}" class="img-fluid rounded shadow-sm" style="max-height: 320px; object-fit: contain;">
                    <div class="mt-3">
                        <span class="badge \${l.disponible ? 'bg-success' : 'bg-warning text-dark'} px-3 py-2">
                            \${l.disponible ? 'Disponible' : 'En préstamo'}
                        </span>
                    </div>
                </div>
                <div class="col-md-8">
                    <h4 class="fw-bold text-primary mb-2">\${l.titulo}</h4>
                    <p class="text-muted mb-3">\${l.autor}</p>
                    <div class="row g-2">
                        <div class="col-md-6"><strong>Editorial:</strong> \${l.editorial}</div>
                        <div class="col-md-6"><strong>Año:</strong> \${l.anio}</div>
                        <div class="col-md-6"><strong>Género:</strong> \${l.genero}</div>
                        <div class="col-md-6"><strong>Idioma:</strong> \${l.idioma}</div>
                        <div class="col-md-6"><strong>ISBN:</strong> \${l.isbn}</div>
                        <div class="col-md-6"><strong>Páginas:</strong> \${l.paginas}</div>
                        <div class="col-md-6"><strong>Copias:</strong> \${l.copias}</div>
                        <div class="col-md-6"><strong>Ubicación:</strong> \${l.ubicacion}</div>
                        <div class="col-md-6"><strong>Nivel:</strong> \${l.nivel}</div>
                        <div class="col-md-6"><strong>Tipo:</strong> \${l.disponible ? 'Préstamo' : 'Consulta en sala'}</div>`;
            if (!l.disponible && l.fechaDisponible) {
                detalle += `<div class="col-12 mt-2"><strong>Disponible a partir de:</strong> \${l.fechaDisponible}</div>`;
            }
            detalle += `</div></div></div>`;

            document.getElementById("detalleLibro").innerHTML = detalle;
            new bootstrap.Modal(document.getElementById("modalVerLibro")).show();
        };

        // --- EDITAR LIBRO ---
        window.editarLibro = (i) => {
            const l = libros[i];
            document.getElementById("indiceLibro").value = i;
            document.getElementById("tituloLibro").value = l.titulo;
            document.getElementById("autorLibro").value = l.autor;
            document.getElementById("anioLibro").value = l.anio;
            document.getElementById("generoLibro").value = l.genero;
            document.getElementById("idiomaLibro").value = l.idioma;
            document.getElementById("editorialLibro").value = l.editorial;
            document.getElementById("isbnLibro").value = l.isbn;
            document.getElementById("paginasLibro").value = l.paginas;
            document.getElementById("copiasLibro").value = l.copias;
            document.getElementById("ubicacionLibro").value = l.ubicacion;
            document.getElementById("nivelLibro").value = l.nivel;
            document.getElementById("disponibleLibro").value = l.disponible;
            document.getElementById("fechaDisponibleLibro").value = l.fechaDisponible;

            tituloModal.innerHTML = "<i class='bi bi-pencil me-2'></i> Editar libro";
            modalHeader.classList.remove("bg-success", "text-white");
            modalHeader.classList.add("bg-warning", "text-dark");

            new bootstrap.Modal(document.getElementById("modalLibro")).show();
        };

        // --- ELIMINAR LIBRO ---
        window.confirmarEliminar = (i) => {
            indiceAEliminar = i;
            new bootstrap.Modal(document.getElementById("modalEliminarLibro")).show();
        };

        document.getElementById("btnConfirmarEliminar").addEventListener("click", () => {
            if (indiceAEliminar !== null) {
                libros.splice(indiceAEliminar, 1);
                renderLibros(libros);
                bootstrap.Modal.getInstance(document.getElementById("modalEliminarLibro")).hide();
            }
        });
    });
</script>


<jsp:include page="components/footer.jsp" />
