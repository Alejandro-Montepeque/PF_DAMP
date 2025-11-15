/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao.NivelEducativoDAOImpl;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.NivelesEducativo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *s
 * @author Abner
 */
@WebServlet(name = "NivelesServlet", urlPatterns = {"/api/niveles"})
public class NivelesServlet extends HttpServlet {
    private final NivelEducativoDAOImpl nivelesDAO = new NivelEducativoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            List<NivelesEducativo> listaNiveles = nivelesDAO.obtenerTodos();

            if (listaNiveles == null || listaNiveles.isEmpty()) {
                out.write("[]");
                return;
            }

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < listaNiveles.size(); i++) {
                NivelesEducativo n = listaNiveles.get(i);

                // Evita nulls y escapa caracteres especiales
                String nombreSeguro = n.getNombre() != null ? n.getNombre().replace("\"", "\\\"") : "";

                json.append(String.format("{\"id_nivel\":%d,\"nombre\":\"%s\"}",
                        n.getIdNivel(), nombreSeguro));

                if (i < listaNiveles.size() - 1) {
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
