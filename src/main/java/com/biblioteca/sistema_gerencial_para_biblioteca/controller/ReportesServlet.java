package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.LibroDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.ProveedorDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.UsuarioDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;
import com.biblioteca.sistema_gerencial_para_biblioteca.reports.ReporteLibrosPDF;
import com.biblioteca.sistema_gerencial_para_biblioteca.reports.ReporteUsuariosPDF;
import com.biblioteca.sistema_gerencial_para_biblioteca.reports.ReporteProveedoresPDF;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ReportesServlet", urlPatterns = {"/ReportesServlet"})
public class ReportesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String tipo = request.getParameter("tipo");
        if (tipo == null) tipo = "";

        try {
            switch (tipo) {
                case "libros":
                    generarReporteLibros(response);
                    break;

                case "usuarios":
                    generarReporteUsuarios(response);
                    break;

                case "proveedores":
                    generarReporteProveedores(response);
                    break;

                default:
                
                    request.getRequestDispatcher("WEB-INF/views/reportes.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error generando reporte PDF: " + e.getMessage(), e);
        }
    }

    private void generarReporteLibros(HttpServletResponse response) throws Exception {
        LibroDAOImpl dao = new LibroDAOImpl();
        List<Libro> lista = dao.obtenerTodos();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Reporte_Libros.pdf");

        ReporteLibrosPDF pdf = new ReporteLibrosPDF();
        pdf.generar(lista, response.getOutputStream());
    }

    private void generarReporteUsuarios(HttpServletResponse response) throws Exception {
        UsuarioDAOImpl dao = new UsuarioDAOImpl();
        List<Usuario> lista = dao.obtenerTodos();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Reporte_Usuarios.pdf");

        ReporteUsuariosPDF pdf = new ReporteUsuariosPDF();
        pdf.generar(lista, response.getOutputStream());
    }

    private void generarReporteProveedores(HttpServletResponse response) throws Exception {
        ProveedorDAOImpl dao = new ProveedorDAOImpl();
        List<Proveedore> lista = dao.obtenerTodos();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Reporte_Proveedores.pdf");

        ReporteProveedoresPDF pdf = new ReporteProveedoresPDF();
        pdf.generar(lista, response.getOutputStream());
    }
}