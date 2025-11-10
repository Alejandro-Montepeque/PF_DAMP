/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;
import jakarta.servlet.http.HttpServlet; 
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException; // <-- Probablemente también lo necesites
import java.io.IOException; // <-- Y este
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsuarioDAOImpl dao = new UsuarioDAOImpl();
        String email = request.getParameter("email");
        String clave = request.getParameter("clave");
        Usuario usuarioLoged = dao.obtenerPorEmail(email);
        if (dao.validateUser(email, clave)) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", usuarioLoged.getNombre());
            sesion.setAttribute("rol", "admin");

            // Redirigir al servlet del dashboard 
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");

        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false); // false = no crear una nueva si no existe

        if (sesion != null && sesion.getAttribute("usuario") != null) {
            // 🟢 Ya hay una sesión activa → redirigimos al dashboard
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        } else {
            // 🔴 No hay sesión → mostramos el login normalmente
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    // ----------------------------------------------------------
    // Métodos auxiliares “mock” (temporalmente sin base de datos)
    // ----------------------------------------------------------
    private boolean validarUsuario(String usuario, String clave) {
        // Usuarios simulados
        return ("admin".equals(usuario) && "admin123".equals(clave))
                || ("user".equals(usuario) && "user123".equals(clave));
    }

    private String obtenerRolMock(String usuario) {
        return "admin".equals(usuario) ? "ADMIN" : "USER";
    }
}
