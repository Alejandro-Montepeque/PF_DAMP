package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Asigna una URL a este Servlet
@WebServlet("/test-conexion")
public class TestConexionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String mensaje;
        
        try {
            // --- EL TEST ---
            // obtener el "volante"
            EntityManager em = JPAUtil.getEntityManager();
            
            // Cierra la conexión de prueba.
            em.close();
            
            mensaje = "Conexion establecida.";
            
        } catch (Exception e) {
            // captura el error
            e.printStackTrace(); 
            mensaje = "Error en la conexion: " + e.getMessage();
        }
        
        // envía el mensaje a la vista
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("/WEB-INF/views/resultadoTest.jsp").forward(request, response);
    }
}