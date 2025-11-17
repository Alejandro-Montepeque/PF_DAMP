/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.RolDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Role;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.Cookie;
import java.net.URLEncoder;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAOImpl daoUsuario = new UsuarioDAOImpl();
        String email = request.getParameter("email");
        String clave = request.getParameter("clave");
        Usuario usuarioLoged = daoUsuario.obtenerPorEmail(email);
        if (usuarioLoged == null) {
            request.setAttribute("error", "El email ingresado no existe.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        } else if (usuarioLoged.getActivo() == false) {
            request.setAttribute("error", "El usuario no esta habilitado");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        } else {
            Role rol = usuarioLoged.getIdRol();
            if (daoUsuario.validateUser(email, clave)) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", usuarioLoged.getNombre());
                sesion.setAttribute("rol", rol.getNombre());
                sesion.setAttribute("id", usuarioLoged.getIdUsuario());

                // Cookie de usuario
                String nombreCodificado = URLEncoder.encode(usuarioLoged.getNombre(), "UTF-8");

                Cookie userCookie = new Cookie("usuario", nombreCodificado);
                userCookie.setMaxAge(60 * 60 * 24 * 30); // 30 días
                userCookie.setPath("/");
                response.addCookie(userCookie);

                // Cookie del rol
                Cookie rolCookie = new Cookie("rol", rol.getNombre());
                rolCookie.setMaxAge(60 * 60 * 24 * 30); // 30 días
                rolCookie.setPath("/");
                response.addCookie(rolCookie);
                
                Cookie idCookie = new Cookie("id",  usuarioLoged.getIdUsuario().toString());
                idCookie.setMaxAge(60 * 60 * 24 * 30); // 30 días
                idCookie.setPath("/");
                response.addCookie(idCookie);

                // Redirigir al servlet del dashboard 
                response.sendRedirect(request.getContextPath() + "/DashboardServlet");

            } else {
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
                dispatcher.forward(request, response);
            }
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false); // false = no crear una nueva si no existe

        if (sesion != null && sesion.getAttribute("usuario") != null) {

            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        } else {

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        }
    }

}
