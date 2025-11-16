package com.biblioteca.sistema_gerencial_para_biblioteca.controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.nio.file.Files;

/**
 *
 * @author Abner
 */
//@WebServlet(urlPatterns = {"/ImagenesServlet"})
@WebServlet("/images/*")
public class ImagenesServlet extends HttpServlet {
      private String getUploadPath() {
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("win")) {
   
            return "C:\\storage\\img\\";
        } else {
       
            return "/srv/biblioteca/storage/img/"; 
        }
      }
    private final String RUTA_BASE = getUploadPath();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String pathInfo = request.getPathInfo(); // /nombre.jpg
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String nombreArchivo = pathInfo.substring(1);
        File archivo = new File(RUTA_BASE + nombreArchivo);

        if (!archivo.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Detectar MIME type automáticamente
        String mime = getServletContext().getMimeType(archivo.getName());
        if (mime == null) mime = "application/octet-stream";

        response.setContentType(mime);
        response.setHeader("Content-Length", String.valueOf(archivo.length()));

        // Enviar el archivo
        Files.copy(archivo.toPath(), response.getOutputStream());
    }
}