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

@WebServlet(name = "UsuariosServlet", urlPatterns = {"/UsuariosServlet"})
public class UsuariosServlet extends HttpServlet {

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.print("Hasta aqui se ejecuto el servlet");
            //Leer los parámetros del formulario (usando los 'name')
            String nombre = request.getParameter("nombre");
            String fechaStr = request.getParameter("fechaNacimiento");
            String sexo = request.getParameter("sexo");
            String direccion = request.getParameter("direccion");
            String dui = request.getParameter("dui");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String tipoUsuario = request.getParameter("tipoUsuario");
            String password = request.getParameter("password");
            String passwordConfirm = request.getParameter("passwordConfirm");
            int idRol = Integer.parseInt(request.getParameter("rolUsuario"));
            
            //Un checkbox marcado envía "on". Si no, envía null.
            boolean activo = request.getParameter("activo") != null; 

            //Validación (simple)
            if (!password.equals(passwordConfirm)) {
                // (Aquí manejaríamos el error, pero por ahora nos saltamos esto)
                throw new ServletException("Las contraseñas no coinciden");
            }
            
            //Hashear la contraseña
            String hash = PasswordUtil.hashPassword(password);
            
            //Traer el objeto Rol
            EntityManager em = JPAUtil.getEntityManager();
            Role rol = em.find(Role.class, idRol);
            em.close();

            //Crear el objeto Usuario y setear todo
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombre(nombre);
            nuevoUsuario.setFechaNacimiento(java.sql.Date.valueOf(fechaStr)); // Convertir String a Date
            nuevoUsuario.setSexo(sexo);
            nuevoUsuario.setDireccion(direccion);
            nuevoUsuario.setDui(dui);
            nuevoUsuario.setTelefono(telefono);
            nuevoUsuario.setEmail(email);
            nuevoUsuario.setTipoUsuario(tipoUsuario);
            nuevoUsuario.setPasswordHash(hash);
            nuevoUsuario.setIdRol(rol);
            nuevoUsuario.setActivo(activo);
            System.out.print("Hasta aqui se ejecuto el servlet" + nuevoUsuario.getNombre());
            // Guardar en la BD
            IUsuarioDAO dao = new UsuarioDAOImpl();
            dao.crear(nuevoUsuario);

            // Redirigir a la página principal de usuarios
            response.sendRedirect(request.getContextPath() + "/UsuariosServlet"); // O la URL de tu servlet principal

        } catch (Exception e) {
  
            e.printStackTrace();
            System.out.print("aqui trono el servlet");
            response.sendRedirect(request.getContextPath() + "/UsuariosServlet");
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

        // Mostrar la vista protegida
        request.getRequestDispatcher("WEB-INF/views/usuarios.jsp").forward(request, response);
    }
}
