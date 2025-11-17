/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import java.io.IOException;
import jakarta.servlet.http.HttpServlet; 
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException; 
import java.io.IOException; 
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.ILibroDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.LibroDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.PrestamoDAOImpl;


@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Verificar si hay usuario logeado
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        ILibroDAO daoLibro = new LibroDAOImpl();
        int libroCount = daoLibro.obtenerTotal();
        IUsuarioDAO dao = new UsuarioDAOImpl();
        int usuarioCount = dao.obtenerActivos();
        IPrestamoDAO daoPrestamo = new PrestamoDAOImpl();
        int cantPrestamosActivos = daoPrestamo.obtenerPendientes();
        request.setAttribute("usuariosActivos", usuarioCount);
        request.setAttribute("cantidadLibros", libroCount);  
        request.setAttribute("cantidadPrestamos", cantPrestamosActivos);
        // Mostrar la vista protegida
        request.getRequestDispatcher("WEB-INF/views/dashboard.jsp").forward(request, response);
    }
        @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response){
    
    
    }
}
