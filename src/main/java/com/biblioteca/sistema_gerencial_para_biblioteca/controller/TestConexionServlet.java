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
//@WebServlet("/test-conexion")
public class TestConexionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String mensaje;
        
        try {
            // --- EL TEST ---
            // 1. Intenta obtener el "volante"
            EntityManager em = JPAUtil.getEntityManager();
            
            // 2. Si lo obtiene, ¡éxito! Cierra la conexión de prueba.
            em.close();
            
            mensaje = "¡ÉXITO! Conexión a la BD lograda. JPAUtil y persistence.xml funcionan.";
            
        } catch (Exception e) {
            // 3. Si falla, captura el error
            e.printStackTrace(); // Muestra el error completo en la consola de Tomcat
            mensaje = "¡ERROR! No se pudo conectar: " + e.getMessage();
        }
        
        // 4. Envía el mensaje a la vista
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("/resultadoTest.jsp").forward(request, response);
    }
}