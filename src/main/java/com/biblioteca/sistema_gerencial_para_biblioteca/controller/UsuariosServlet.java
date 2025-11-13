/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.PasswordUtil;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.*;
import jakarta.persistence.EntityManager;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import java.util.List;

@WebServlet(name = "UsuariosServlet", urlPatterns = {"/UsuariosServlet"})
public class UsuariosServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            String idUsuarioStr = request.getParameter("usuarioId");
            IUsuarioDAO dao = new UsuarioDAOImpl();
            String nombre = request.getParameter("nombre");
            String fechaStr = request.getParameter("fechaNacimiento");
            String sexo = request.getParameter("sexo");
            String direccion = request.getParameter("direccion");
            String dui = request.getParameter("dui");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String tipoUsuario = request.getParameter("tipoUsuario");
            int idRol = 3;

            boolean activo = request.getParameter("activo") != null;

            //Hashear la contraseña
            //Traer el objeto Rol
            EntityManager em = JPAUtil.getEntityManager();
            Role rol = em.find(Role.class, idRol);
            em.close();

            if (idUsuarioStr == null || idUsuarioStr.isEmpty()) {


                if (dao.obtenerPorEmail(email) != null) { 
                    throw new ServletException("El correo ya fue registrado");
                }
                // Logica para validar DUI

                // Creamos el objeto 
                Usuario nuevoUsuario = new Usuario();
                nuevoUsuario.setNombre(nombre);
                nuevoUsuario.setFechaNacimiento(java.sql.Date.valueOf(fechaStr));
                nuevoUsuario.setSexo(sexo);
                nuevoUsuario.setDireccion(direccion);
                nuevoUsuario.setDui(dui);
                nuevoUsuario.setTelefono(telefono);
                nuevoUsuario.setEmail(email);
                nuevoUsuario.setTipoUsuario(tipoUsuario);
                nuevoUsuario.setIdRol(rol); //o
                nuevoUsuario.setActivo(activo);
                nuevoUsuario.setPasswordHash(null);

                dao.crear(nuevoUsuario);
                session.setAttribute("mensajeExito", "¡Usuario creado exitosamente!");

            } else {
  
                int idUsuario = Integer.parseInt(idUsuarioStr);
                Usuario usuarioAEditar = dao.obtenerPorId(idUsuario);

                if (usuarioAEditar == null) {
                    throw new ServletException("El usuario a editar no existe.");
                }


                Usuario emailExistente = dao.obtenerPorEmail(email);
                if (emailExistente != null && emailExistente.getIdUsuario() != usuarioAEditar.getIdUsuario()) {
                    throw new ServletException("Ese email ya está en uso por otro usuario.");
                }

                usuarioAEditar.setNombre(nombre);
                usuarioAEditar.setFechaNacimiento(java.sql.Date.valueOf(fechaStr));
                usuarioAEditar.setSexo(sexo);
                usuarioAEditar.setDireccion(direccion);
                usuarioAEditar.setDui(dui);
                usuarioAEditar.setTelefono(telefono);
                usuarioAEditar.setEmail(email);
                usuarioAEditar.setTipoUsuario(tipoUsuario);
                usuarioAEditar.setIdRol(rol);
                usuarioAEditar.setActivo(activo);
                usuarioAEditar.setPasswordHash(null);

                dao.actualizar(usuarioAEditar);
                session.setAttribute("mensajeExito", "¡Usuario actualizado exitosamente!");
            }

            response.sendRedirect(request.getContextPath() + "/UsuariosServlet"); // URL 

        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al guardar el usuario: " + e.getMessage());
            e.printStackTrace();

            response.sendRedirect(request.getContextPath() + "/UsuariosServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

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
            IUsuarioDAO dao = new UsuarioDAOImpl();
            List<Usuario> listaUsuarios = dao.obtenerPorRol(3);

            request.setAttribute("listaUsuarios", listaUsuarios);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error al cargar la lista de usuarios: " + e.getMessage());
        }

        request.getRequestDispatcher("WEB-INF/views/usuarios.jsp").forward(request, response);
    }
}
