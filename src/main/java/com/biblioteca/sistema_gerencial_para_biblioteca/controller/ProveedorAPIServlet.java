package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.ProveedorDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IProveedorDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * API Servlet para obtener todos los proveedores en formato JSON.
 * 
 * @author Abner Lopez
 */
@WebServlet(name = "ProveedorAPIServlet", urlPatterns = {"/api/proveedores"})
public class ProveedorAPIServlet extends HttpServlet {
    
    private final IProveedorDAO proveedorDAO = new ProveedorDAOImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            List<Proveedore> listaProveedores = proveedorDAO.obtenerTodos();
            
            if (listaProveedores == null || listaProveedores.isEmpty()) {
                out.write("[]");
                return;
            }
            
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            
            for (Proveedore p : listaProveedores) {
                // Solo incluir proveedores activos
                if (!p.getActivo()) {
                    continue;
                }
                
                if (!first) {
                    json.append(",");
                }
                first = false;
                
                // Evita nulls y escapa caracteres especiales
                String nombreSeguro = p.getNombre() != null 
                    ? p.getNombre().replace("\"", "\\\"") 
                    : "";
                
                json.append(String.format("{\"id_proveedor\":%d,\"nombre\":\"%s\"}",
                        p.getIdProveedor(), nombreSeguro));
            }
            
            json.append("]");
            out.write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error al obtener los proveedores\"}");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "API REST que devuelve todos los proveedores en formato JSON";
    }
}