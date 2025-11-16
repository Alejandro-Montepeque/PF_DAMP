package com.biblioteca.sistema_gerencial_para_biblioteca.reports;

import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Font;
import com.lowagie.text.Element;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.draw.LineSeparator;

import java.awt.Color;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ReporteUsuariosPDF {

    public void generar(List<Usuario> usuarios, OutputStream out) throws Exception {
        Document doc = new Document(PageSize.LETTER.rotate());
        PdfWriter.getInstance(doc, out);
        doc.open();

      
        Font tituloFont = new Font(Font.HELVETICA, 20, Font.BOLD, Color.BLACK);
        Font subFont = new Font(Font.HELVETICA, 12, Font.NORMAL, new Color(80, 80, 80));

        Paragraph titulo = new Paragraph("REPORTE DE USUARIOS", tituloFont);
        titulo.setAlignment(Element.ALIGN_CENTER);
        doc.add(titulo);

        Paragraph fecha = new Paragraph(
                "Generado el " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()),
                subFont
        );
        fecha.setAlignment(Element.ALIGN_CENTER);
        doc.add(fecha);

        doc.add(new Paragraph("\n"));

        LineSeparator linea = new LineSeparator();
        linea.setLineColor(new Color(150, 150, 150));
        doc.add(linea);
        doc.add(new Paragraph("\n"));

      
        PdfPTable tabla = new PdfPTable(8);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(10);
        float[] anchos = {6, 28, 10, 30, 14, 14, 12, 10};
        tabla.setWidths(anchos);

        String[] headers = {"ID", "Nombre", "DUI", "Email", "Teléfono", "Rol", "Tipo Usuario", "Estado"};
        Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);

        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(new Color(33, 37, 41));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(6);
            tabla.addCell(cell);
        }

        Font filaFont = new Font(Font.HELVETICA, 9);

        for (Usuario u : usuarios) {
            tabla.addCell(new Phrase(String.valueOf(u.getIdUsuario()), filaFont));
            tabla.addCell(new Phrase(ns(u.getNombre()), filaFont));
            tabla.addCell(new Phrase(ns(u.getDui()), filaFont));
            tabla.addCell(new Phrase(ns(u.getEmail()), filaFont));
            tabla.addCell(new Phrase(ns(u.getTelefono()), filaFont));

            String rol = (u.getIdRol() != null) ? ns(u.getIdRol().getNombre()) : "-";
            tabla.addCell(new Phrase(rol, filaFont));

            tabla.addCell(new Phrase(ns(u.getTipoUsuario()), filaFont));

            String estado = u.getActivo() ? "Activo" : "Inactivo";
            tabla.addCell(new Phrase(estado, filaFont));
        }

        doc.add(tabla);
        doc.close();
    }

    private String ns(String v) { return v == null ? "-" : v; }
}
