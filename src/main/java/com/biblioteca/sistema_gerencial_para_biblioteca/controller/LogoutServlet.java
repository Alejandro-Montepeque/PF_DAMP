/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

    // Borrar cookie usuario
        Cookie cookieUsuario = new Cookie("usuario", "");
        cookieUsuario.setMaxAge(0);
        cookieUsuario.setPath("/");
        response.addCookie(cookieUsuario);

    // Borrar cookie rol
        Cookie cookieRol = new Cookie("rol", "");
        cookieRol.setMaxAge(0);
        cookieRol.setPath("/");
        response.addCookie(cookieRol);

        response.sendRedirect(request.getContextPath() + "/LoginServlet");

    }
}
