/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.ILibroDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.LibroDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.*;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

/**
 *
 * @author LuisElias
 */
@WebServlet(name = "LibrosServlet", urlPatterns = {"/LibrosServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 10,   // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class LibrosServlet extends HttpServlet {

        private String getUploadPath() {
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("win")) {
   
            return "C:\\storage\\img\\";
        } else {
       
            return "/srv/biblioteca/storage/img/"; 
        }
    }
      @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Verificar si hay usuario logeado
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // 1. Tu código de seguridad (está perfecto)
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 2. ¡ESTA ES LA LÓGICA "FLASH"!
        // Mueve el mensaje de la Sesión al Request
        if (session.getAttribute("mensajeExito") != null) {
            request.setAttribute("mensajeExito", session.getAttribute("mensajeExito"));
            session.removeAttribute("mensajeExito"); // Se borra para que no se repita
        }

        if (session.getAttribute("mensajeError") != null) {
            request.setAttribute("mensajeError", session.getAttribute("mensajeError"));
            session.removeAttribute("mensajeError"); // Se borra
        }

        try {
            ILibroDAO dao = new LibroDAOImpl();
            List<Libro> listaLibros = dao.obtenerTodos();

            // Ponemos la lista en el request para que el JSP la pueda usar
            request.setAttribute("listaLibros", listaLibros);

        } catch (Exception e) {
            e.printStackTrace();
            // Si hay un error al cargar, envía un mensaje de error
            request.setAttribute("mensajeError", "Error al cargar la lista de libros: " + e.getMessage());
        }
        // 3. Envía al JSP (ahora el 'request' lleva el mensaje)
        request.getRequestDispatcher("WEB-INF/views/libros.jsp").forward(request, response);

    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        try {
            // Datos del form
            String idLibroStr = request.getParameter("libroId");
            String titulo = request.getParameter("titulo");
            String anioStr = request.getParameter("anioPublicacion");
            String idioma = request.getParameter("idioma");
            String isbn = request.getParameter("isbn");
            String paginasStr = request.getParameter("numPaginas");
            String disponiblesStr = request.getParameter("cantDisponibles");
            String fechaStr = request.getParameter("fechaAdquisicion");
            
            // Para activo
            //String activoStr = request.getParameter("activo");
            //Boolean activo = activoStr != null ? Boolean.parseBoolean(activoStr) : true;
            boolean activo = request.getParameter("activo") != null;
            
            // Para imagen
            Part imagenPart = request.getPart("imagenPortada");
            String nombreImagen = null;
           
            if (imagenPart != null && imagenPart.getSize() > 0) {
               String rutaUpload = getUploadPath();

                // Crear carpeta si no existe
                File uploadDir = new File(rutaUpload);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Obtener el nombre original
                String fileName = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();
                String extension = fileName.substring(fileName.lastIndexOf(".")); // .jpg / .png

                // Crear nombre único
                String nombreFinal = "libro_" + System.currentTimeMillis() + extension;

                // Guardar en disco
                File archivoDestino = new File(rutaUpload + nombreFinal);
                imagenPart.write(archivoDestino.getAbsolutePath());

                // Guardar SOLO el nombre para la BD
                nombreImagen = nombreFinal;
            }
            

            String idGeneroStr = request.getParameter("idGenero");
            String idNivelStr = request.getParameter("idNivelEducativo");
            //String idProveedorStr = request.getParameter("idProveedor");
            String idProveedorStr = null;
          
            EntityManager em = JPAUtil.getEntityManager();
            LibroDAOImpl dao = new LibroDAOImpl();

            Integer anio = (anioStr != null && !anioStr.isEmpty()) ? Integer.parseInt(anioStr) : null;
            Integer numPaginas = (paginasStr != null && !paginasStr.isEmpty()) ? Integer.parseInt(paginasStr) : null;
            int cantDisponibles = (disponiblesStr != null && !disponiblesStr.isEmpty()) ? Integer.parseInt(disponiblesStr) : 0;
            java.sql.Date fechaAdquisicion = (fechaStr != null && !fechaStr.isEmpty()) ? java.sql.Date.valueOf(fechaStr) : null;

            // Entidades relacionadas
            Genero genero = null;
            NivelesEducativo nivel = null;
            //Proveedore proveedor = null;

            if (idGeneroStr != null && !idGeneroStr.isEmpty()) {
                genero = em.find(Genero.class, Integer.parseInt(idGeneroStr));
            }
            if (idNivelStr != null && !idNivelStr.isEmpty()) {
                nivel = em.find(NivelesEducativo.class, Integer.parseInt(idNivelStr));
            }
            if (idProveedorStr != null && !idProveedorStr.isEmpty()) {
                //proveedor = em.find(Proveedore.class, Integer.parseInt(idProveedorStr));
            }
            
            // Crear o actualizar
            if (idLibroStr == null || idLibroStr.isEmpty()) {
                // Crear nuevo libro
                Libro nuevo = new Libro();
                nuevo.setTitulo(titulo);
                nuevo.setAnioPublicacion(anio);
                nuevo.setIdioma(idioma);
                nuevo.setIsbn(isbn);
                nuevo.setNumPaginas(numPaginas);
                nuevo.setCantDisponibles(cantDisponibles);
                nuevo.setFechaAdquisicion(fechaAdquisicion);
                nuevo.setActivo(activo);
                if (nombreImagen != null) {
                    nuevo.setImagenPortada(nombreImagen);
                }
                
                nuevo.setIdGenero(genero);
                nuevo.setIdNivelEducativo(nivel);
                //nuevo.setIdProveedor(proveedor);

                dao.crear(nuevo);
                session.setAttribute("mensajeExito", "¡Libro agregado exitosamente!");
            } else {
                // Editar libro existente
                int idLibro = Integer.parseInt(idLibroStr);
                Libro libroExistente = dao.obtenerPorId(idLibro);

                if (libroExistente == null) {
                    throw new ServletException("El libro con ID " + idLibro + " no existe.");
                }

                libroExistente.setTitulo(titulo);
                libroExistente.setAnioPublicacion(anio);
                libroExistente.setIdioma(idioma);
                libroExistente.setIsbn(isbn);
                libroExistente.setNumPaginas(numPaginas);
                libroExistente.setCantDisponibles(cantDisponibles);
                libroExistente.setFechaAdquisicion(fechaAdquisicion);
                libroExistente.setActivo(activo);
                //libroExistente.setImagenPortada(imagen);
                if (nombreImagen != null) {
                    libroExistente.setImagenPortada(nombreImagen);
                }
                
                libroExistente.setIdGenero(genero);
                libroExistente.setIdNivelEducativo(nivel);
                //libroExistente.setIdProveedor(proveedor);

                dao.actualizar(libroExistente);
                session.setAttribute("mensajeExito", "¡Libro actualizado exitosamente!");
            }

            response.sendRedirect(request.getContextPath() + "/LibrosServlet");

        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al guardar el libro: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/LibrosServlet");
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID requerido");
            return;
        }

        int idLibro = Integer.parseInt(idStr);

        EntityManager em = JPAUtil.getEntityManager();
        
        try {
            Libro libro = em.find(Libro.class, idLibro);

            if (libro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Libro no existe");
                return;
            }

            em.getTransaction().begin();
            em.remove(libro);
            em.getTransaction().commit();

            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error eliminando libro");
        } finally {
            em.close();
        }
    }
}
