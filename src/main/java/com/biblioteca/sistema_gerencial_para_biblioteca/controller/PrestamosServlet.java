package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.*;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.*;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "PrestamosServlet", urlPatterns = {"/PrestamosServlet"})
public class PrestamosServlet extends HttpServlet {

    private final IPrestamoDAO prestamoDAO = new PrestamoDAOImpl();
    private final IUsuarioDAO usuarioDAO = new UsuarioDAOImpl();
    private final ILibroDAO libroDAO = new LibroDAOImpl();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {

            Object idObj = session.getAttribute("id");
            if (idObj == null) throw new Exception("No hay sesión activa");

            int idBibliotecario = Integer.parseInt(idObj.toString());
            Usuario bibliotecario = usuarioDAO.obtenerPorId(idBibliotecario);

            if (bibliotecario == null)
                throw new Exception("Bibliotecario no encontrado en BD");

            String emailUsuario = request.getParameter("emailUsuario");
            Usuario lector = usuarioDAO.obtenerPorEmail(emailUsuario);

            if (lector == null)
                throw new Exception("El usuario con email '" + emailUsuario + "' no existe.");

            String tituloLibro = request.getParameter("tituloLibro");
            Libro libro = libroDAO.obtenerPorTitulo(tituloLibro);

            if (libro == null)
                throw new Exception("El libro '" + tituloLibro + "' no existe.");

            Date fechaPrestamo = sdf.parse(request.getParameter("fechaPrestamo"));
            Date fechaEstimada = sdf.parse(request.getParameter("fechaEstimada"));

            Date fechaReal = null;
            String fechaRealStr = request.getParameter("fechaReal");
            if (fechaRealStr != null && !fechaRealStr.isEmpty()) {
                fechaReal = sdf.parse(fechaRealStr);
            }

            String idPrestamoStr = request.getParameter("idPrestamo");
            boolean editar = idPrestamoStr != null && !idPrestamoStr.isEmpty();

            if (!editar) {
                Prestamo nuevo = new Prestamo();

                nuevo.setIdUsuario(lector);
                nuevo.setIdLibro(libro);
                nuevo.setIdBibliotecario(bibliotecario);
                nuevo.setFechaPrestamo(fechaPrestamo);
                nuevo.setFechaEntregaEstimada(fechaEstimada);
                nuevo.setEstado("Pendiente");
                nuevo.setObservaciones(request.getParameter("observaciones"));

                prestamoDAO.crear(nuevo);
                session.setAttribute("mensajeExito", "¡Préstamo creado exitosamente!");

            } else {
                int idPrestamo = Integer.parseInt(idPrestamoStr);
                Prestamo existente = prestamoDAO.obtenerPorId(idPrestamo);

                if (existente == null) throw new Exception("El préstamo no existe.");

                existente.setIdUsuario(lector);
                existente.setIdLibro(libro);
                existente.setIdBibliotecario(bibliotecario);
                existente.setFechaPrestamo(fechaPrestamo);
                existente.setFechaEntregaEstimada(fechaEstimada);
                existente.setFechaEntregaReal(fechaReal);
                existente.setEstado(request.getParameter("estado"));
                existente.setObservaciones(request.getParameter("observaciones"));

                prestamoDAO.actualizar(existente);
                session.setAttribute("mensajeExito", "¡Préstamo actualizado correctamente!");
            }

        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute("mensajeError",
                    "Error al procesar préstamo: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/PrestamosServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // SweetAlerts
        if (session.getAttribute("mensajeExito") != null) {
            request.setAttribute("mensajeExito", session.getAttribute("mensajeExito"));
            session.removeAttribute("mensajeExito");
        }
        if (session.getAttribute("mensajeError") != null) {
            request.setAttribute("mensajeError", session.getAttribute("mensajeError"));
            session.removeAttribute("mensajeError");
        }

        try {

            List<Usuario> usuarios = usuarioDAO.obtenerTodos();
            List<String> emails = new ArrayList<>();

            for (Usuario u : usuarios) {
                if (u.getEmail() != null) emails.add(u.getEmail());
            }
            request.setAttribute("emails", emails);

            List<Libro> libros = libroDAO.obtenerDisponibles();
            List<String> titulos = new ArrayList<>();

            for (Libro l : libros) {
                if (l.getTitulo() != null) titulos.add(l.getTitulo());
            }
            request.setAttribute("titulos", titulos);

            List<Prestamo> prestamos = prestamoDAO.listar();
            request.setAttribute("listaPrestamos", prestamos);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error al cargar datos: " + e.getMessage());
        }

        request.getRequestDispatcher("WEB-INF/views/prestamos.jsp").forward(request, response);
    }
}
