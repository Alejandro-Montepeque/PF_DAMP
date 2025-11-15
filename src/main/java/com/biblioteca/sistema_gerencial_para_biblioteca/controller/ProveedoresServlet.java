package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.ProveedorDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IProveedorDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProveedoresServlet", urlPatterns = {"/ProveedoresServlet"})
public class ProveedoresServlet extends HttpServlet {

    private IProveedorDAO dao = new ProveedorDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                this.listarProveedores(request, response);
                break;
            case "eliminar":
                this.eliminarProveedor(request, response);
                break;
            default:
                this.listarProveedores(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String accion = request.getParameter("accion");

        if ("guardar".equals(accion)) {
            this.guardarProveedor(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/ProveedoresServlet");
        }
    }

    // --- MÉTODOS PRIVADOS DE ACCIÓN ---

    private void listarProveedores(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        // 1. Lógica "Flash Attribute" para SweetAlert
        if (session.getAttribute("mensajeExito") != null) {
            request.setAttribute("mensajeExito", session.getAttribute("mensajeExito"));
            session.removeAttribute("mensajeExito");
        }
        if (session.getAttribute("mensajeError") != null) {
            request.setAttribute("mensajeError", session.getAttribute("mensajeError"));
            session.removeAttribute("mensajeError");
        }

        // 2. Lógica de Filtros
        try {
            String filtroTexto = request.getParameter("filtroTexto");
            List<Proveedore> listaProveedores;

            if (filtroTexto != null && !filtroTexto.trim().isEmpty()) {
                listaProveedores = dao.buscarPorNombreOTipo(filtroTexto);
                request.setAttribute("filtroTexto", filtroTexto);
            } else {
                listaProveedores = dao.obtenerTodos();
            }
            
            request.setAttribute("listaProveedores", listaProveedores);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error al cargar la lista de proveedores: " + e.getMessage());
        }

        // 3. Muestra la vista
        request.getRequestDispatcher("WEB-INF/views/proveedores.jsp").forward(request, response);
    }

    private void guardarProveedor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String idProveedorStr = request.getParameter("proveedorId");

        try {
            // --- 1. Leer Datos Comunes ---
            String nombre = request.getParameter("nombre");
            String tipo = request.getParameter("tipo");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String direccion = request.getParameter("direccion");

            // --- 2. Lógica de CREAR (ID está vacío) ---
            if (idProveedorStr == null || idProveedorStr.isEmpty()) {
                
                Proveedore nuevoProveedor = new Proveedore();
                nuevoProveedor.setNombre(nombre);
                nuevoProveedor.setTipo(tipo);
                nuevoProveedor.setTelefono(telefono);
                nuevoProveedor.setEmail(email);
                nuevoProveedor.setDireccion(direccion);
                
                dao.crear(nuevoProveedor);
                session.setAttribute("mensajeExito", "¡Proveedor creado exitosamente!");

            // --- 3. Lógica de ACTUALIZAR (ID existe) ---
            } else {
                
                int idProveedor = Integer.parseInt(idProveedorStr);
                Proveedore proveedorAEditar = dao.obtenerPorId(idProveedor);
                
                if (proveedorAEditar == null) {
                    throw new ServletException("El proveedor a editar no existe.");
                }

                proveedorAEditar.setNombre(nombre);
                proveedorAEditar.setTipo(tipo);
                proveedorAEditar.setTelefono(telefono);
                proveedorAEditar.setEmail(email);
                proveedorAEditar.setDireccion(direccion);

                dao.actualizar(proveedorAEditar);
                session.setAttribute("mensajeExito", "¡Proveedor actualizado exitosamente!");
            }

        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error al guardar el proveedor: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 4. Redirigir de vuelta a la lista (al doGet)
        response.sendRedirect(request.getContextPath() + "/ProveedoresServlet");
    }

    private void eliminarProveedor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id); 
            session.setAttribute("mensajeExito", "Proveedor eliminado correctamente.");
        } catch (Exception e) {
            e.printStackTrace();
            // Captura de error de llave foránea (muy común)
            if (e.getMessage().contains("constraint violation")) {
                session.setAttribute("mensajeError", "Error: No se puede eliminar. Este proveedor está asignado a uno o más libros.");
            } else {
                session.setAttribute("mensajeError", "Error al eliminar el proveedor.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/ProveedoresServlet");
    }
}