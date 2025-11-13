package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.GeneroDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Genero;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * API Servlet para obtener todos los géneros en formato JSON.
 *
 * @author Luis
 */
@WebServlet(name = "GeneroServlet", urlPatterns = {"/api/generos"})
public class GeneroServlet extends HttpServlet {

    private final GeneroDAOImpl generoDAO = new GeneroDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            List<Genero> listaGeneros = generoDAO.obtenerTodos();

            if (listaGeneros == null || listaGeneros.isEmpty()) {
                out.write("[]");
                return;
            }

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < listaGeneros.size(); i++) {
                Genero g = listaGeneros.get(i);

                // Evita nulls y escapa caracteres especiales
                String nombreSeguro = g.getNombre() != null ? g.getNombre().replace("\"", "\\\"") : "";

                json.append(String.format("{\"id_genero\":%d,\"nombre\":\"%s\"}",
                        g.getIdGenero(), nombreSeguro));

                if (i < listaGeneros.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            out.write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error al obtener los géneros\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "API REST que devuelve todos los géneros en formato JSON";
    }
}
