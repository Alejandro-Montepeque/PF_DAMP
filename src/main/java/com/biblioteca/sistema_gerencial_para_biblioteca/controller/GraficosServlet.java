/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.LibroDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.PrestamoDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
/**
 *
 * @author LuisElias
 */
@WebServlet(name = "GraficosServlet", urlPatterns = {"/GraficosServlet"})
public class GraficosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Verificar si hay usuario logeado
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        LibroDAOImpl libroDAO = new LibroDAOImpl();
        PrestamoDAOImpl prestamoDAO = new PrestamoDAOImpl();
        
        int librosDisponibles = libroDAO.contarLibrosDisponibles();
        int librosPrestados = libroDAO.contarLibrosPrestados();
        int devolucionesATiempo = prestamoDAO.contarDevolucionesATiempo();
        int devolucionesAtrasadas = prestamoDAO.contarDevolucionesAtrasadas();
        
        request.setAttribute("librosDisponibles", librosDisponibles);
        request.setAttribute("librosPrestados", librosPrestados);
        request.setAttribute("devolucionesATiempo", devolucionesATiempo);
        request.setAttribute("devolucionesAtrasadas", devolucionesAtrasadas);

        // Mostrar la vista protegida
        request.getRequestDispatcher("WEB-INF/views/graficos.jsp").forward(request, response);
    }
}
