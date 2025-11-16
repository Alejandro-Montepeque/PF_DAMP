package com.biblioteca.sistema_gerencial_para_biblioteca.reports;

import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
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

public class ReporteProveedoresPDF {

    public void generar(List<Proveedore> proveedores, OutputStream out) throws Exception {
        Document doc = new Document(PageSize.LETTER.rotate());
        PdfWriter.getInstance(doc, out);
        doc.open();

       
        Font tituloFont = new Font(Font.HELVETICA, 20, Font.BOLD, Color.BLACK);
        Font subFont = new Font(Font.HELVETICA, 12, Font.NORMAL, new Color(80, 80, 80));

        Paragraph titulo = new Paragraph("REPORTE DE PROVEEDORES", tituloFont);
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

       
        PdfPTable tabla = new PdfPTable(7);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(10);
        float[] anchos = {6, 30, 24, 18, 28, 14, 10};
        tabla.setWidths(anchos);

        String[] headers = {"ID", "Nombre", "Dirección", "Teléfono", "Email", "Tipo", "Estado"};
        Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);

        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(new Color(33, 37, 41));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(6);
            tabla.addCell(cell);
        }

        Font filaFont = new Font(Font.HELVETICA, 9);

        for (Proveedore p : proveedores) {
            tabla.addCell(new Phrase(String.valueOf(p.getIdProveedor()), filaFont));
            tabla.addCell(new Phrase(ns(p.getNombre()), filaFont));
            tabla.addCell(new Phrase(ns(p.getDireccion()), filaFont));
            tabla.addCell(new Phrase(ns(p.getTelefono()), filaFont));
            tabla.addCell(new Phrase(ns(p.getEmail()), filaFont));
            tabla.addCell(new Phrase(ns(p.getTipo()), filaFont));
            String estado = p.getActivo() ? "Activo" : "Inactivo";
            tabla.addCell(new Phrase(estado, filaFont));
        }

        doc.add(tabla);
        doc.close();
    }

    private String ns(String v) { return v == null ? "-" : v; }
}
