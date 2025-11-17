/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.LibroDAOImpl;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.PrestamoDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.ILibroDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.*;
import java.util.List;
import com.google.gson.Gson;
import jakarta.persistence.EntityManager;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author LuisElias
 */
@WebServlet(name = "PrestamosServlet", urlPatterns = {"/PrestamosServlet"})
public class PrestamosServlet extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();

    try {
        // ----------- 1. VALIDACIONES BÁSICAS --------------
        String idPrestamoStr = request.getParameter("idPrestamo");
        String idUsuarioStr = request.getParameter("idUsuario");

        if (idUsuarioStr == null || idUsuarioStr.isEmpty()) {
            throw new ServletException("Debe seleccionar un usuario.");
        }
        int idUsuario = Integer.parseInt(idUsuarioStr);
        int idBibliotecario = Integer.parseInt(session.getAttribute("id").toString());

        String[] idLibrosArray = request.getParameterValues("idLibro");
        if (idLibrosArray == null || idLibrosArray.length == 0) {
            throw new ServletException("Debe seleccionar al menos un libro.");
        }

        Date fechaPrestamo = java.sql.Date.valueOf(request.getParameter("fechaPrestamo"));
        Date fechaEstimada = java.sql.Date.valueOf(request.getParameter("fechaEstimada"));

        String fechaRealStr = request.getParameter("fechaReal");
        Date fechaReal = (fechaRealStr != null && !fechaRealStr.isEmpty())
                ? java.sql.Date.valueOf(fechaRealStr)
                : null;

        String estado = request.getParameter("estado");
        String observaciones = request.getParameter("observaciones");

        // ----------- 2. CARGAR ENTIDADES ------------------
        EntityManager em = JPAUtil.getEntityManager();

        Usuario usuario = em.find(Usuario.class, idUsuario);
        Usuario bibliotecario = em.find(Usuario.class, idBibliotecario);

        if (usuario == null) throw new ServletException("Usuario inválido.");
        if (bibliotecario == null) throw new ServletException("Bibliotecario inválido.");

        // ----------- 3. CREAR O CARGAR PRESTAMO -----------
        PrestamoDAOImpl dao = new PrestamoDAOImpl();
        Prestamo prestamo;

        if (idPrestamoStr == null || idPrestamoStr.isEmpty()) {
            prestamo = new Prestamo();
        } else {
            prestamo = dao.obtenerPorId(Integer.parseInt(idPrestamoStr));
        }

        prestamo.setIdUsuario(usuario);
        prestamo.setIdBibliotecario(bibliotecario);
        prestamo.setFechaPrestamo(fechaPrestamo);
        prestamo.setFechaEntregaEstimada(fechaEstimada);
        prestamo.setFechaEntregaReal(fechaReal);
        prestamo.setObservaciones(observaciones);
        prestamo.setEstado(estado);

        // ----------- 4. CREAR DETALLES --------------------
        List<DetallePrestamo> detalles = new ArrayList<>();

        for (String idLibroStr : idLibrosArray) {
            Libro libro = em.find(Libro.class, Integer.parseInt(idLibroStr));

            DetallePrestamo dp = new DetallePrestamo();
            dp.setPrestamo(prestamo);
            dp.setLibro(libro);

            detalles.add(dp);
        }

        prestamo.setDetallePrestamoList(detalles);

        // ----------- 5. GUARDAR EN LA BD ------------------
        dao.crear(prestamo);

        session.setAttribute("mensajeExito", "¡Préstamo creado exitosamente!");
        response.sendRedirect(request.getContextPath() + "/PrestamosServlet");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("mensajeError", "Error al guardar: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/PrestamosServlet");
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
        // Mueve el mensaje de la Sesion al Request
        if (session.getAttribute("mensajeExito") != null) {
            request.setAttribute("mensajeExito", session.getAttribute("mensajeExito"));
            session.removeAttribute("mensajeExito"); // Se borra para que no se repita
        }

        if (session.getAttribute("mensajeError") != null) {
            request.setAttribute("mensajeError", session.getAttribute("mensajeError"));
            session.removeAttribute("mensajeError"); // Se borra
        }

        try {

            IUsuarioDAO daoUsuario = new UsuarioDAOImpl();
            List<Usuario> listaUsuarios = daoUsuario.obtenerTodos();

            List<Map<String, Object>> usuariosSimple = new ArrayList<>();

            for (Usuario u : listaUsuarios) {
                Map<String, Object> map = new HashMap<>();
                map.put("idUsuario", u.getIdUsuario());
                map.put("nombre", u.getNombre());
                map.put("dui", u.getDui());
                map.put("email", u.getEmail());
                usuariosSimple.add(map);
            }

            String usuariosJson = new Gson().toJson(usuariosSimple);
            request.setAttribute("usuariosJson", usuariosJson);

            // LIBROS
            ILibroDAO daoLibro = new LibroDAOImpl();
            List<Libro> listaLibros = daoLibro.obtenerTodos();

            List<Map<String, Object>> librosSimple = new ArrayList<>();

            for (Libro l : listaLibros) {
                Map<String, Object> map = new HashMap<>();
                map.put("idLibro", l.getIdLibro());
                map.put("titulo", l.getTitulo());
                map.put("isbn", l.getIsbn());
                map.put("cantDisponibles", l.getCantDisponibles());
                librosSimple.add(map);
            }

            String librosJson = new Gson().toJson(librosSimple);
            request.setAttribute("librosJson", librosJson);

            // PRÉSTAMOS
            PrestamoDAOImpl daoPrestamo = new PrestamoDAOImpl();
            List<Prestamo> listaPrestamosEntities = daoPrestamo.listar();

            request.setAttribute("listaPrestamos", listaPrestamosEntities);
        } catch (Exception e) {
            e.printStackTrace();
            // Si hay un error al cargar, envía un mensaje de error
            request.setAttribute("mensajeError", "Error al cargar la lista de prestamos: " + e.getMessage());
        }
        // Mostrar la vista protegida
        request.getRequestDispatcher("WEB-INF/views/prestamos.jsp").forward(request, response);
    }
}
