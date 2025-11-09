/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        if (validarUsuario(usuario, clave)) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", usuario);

            String rol = obtenerRolMock(usuario);
            sesion.setAttribute("rol", rol);

            // 🔁 Redirigir al servlet del dashboard (protege mejor la sesión)
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
