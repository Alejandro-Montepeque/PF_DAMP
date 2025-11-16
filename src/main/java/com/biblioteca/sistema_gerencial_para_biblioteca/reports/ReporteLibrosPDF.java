package com.biblioteca.sistema_gerencial_para_biblioteca.reports;

import com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro;
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

public class ReporteLibrosPDF {

    public void generar(List<Libro> libros, OutputStream out) throws Exception {

        Document doc = new Document(PageSize.LETTER.rotate());
        PdfWriter.getInstance(doc, out);
        doc.open();

        Font tituloFont = new Font(Font.HELVETICA, 20, Font.BOLD, Color.BLACK);
        Font subFont = new Font(Font.HELVETICA, 12, Font.NORMAL, new Color(80, 80, 80));

        Paragraph titulo = new Paragraph("REPORTE DE LIBROS", tituloFont);
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

        PdfPTable tabla = new PdfPTable(10);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(10);

        float[] anchos = {5, 25, 8, 10, 12, 8, 10, 12, 12, 8};
        tabla.setWidths(anchos);

        String[] headers = {
            "ID", "Título", "Año", "Idioma", "ISBN",
            "Páginas", "Cantidad", "Proveedor", "Género", "Estado"
        };

        Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);

        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(new Color(33, 37, 41)); // dark bootstrap tone
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(6);
            tabla.addCell(cell);
        }

        
        Font filaFont = new Font(Font.HELVETICA, 9);

        for (Libro l : libros) {

            tabla.addCell(new Phrase(String.valueOf(l.getIdLibro()), filaFont));
            tabla.addCell(new Phrase(ns(l.getTitulo()), filaFont));
            tabla.addCell(new Phrase(nsInt(l.getAnioPublicacion()), filaFont));
            tabla.addCell(new Phrase(ns(l.getIdioma()), filaFont));
            tabla.addCell(new Phrase(ns(l.getIsbn()), filaFont));
            tabla.addCell(new Phrase(nsInt(l.getNumPaginas()), filaFont));
            tabla.addCell(new Phrase(String.valueOf(l.getCantDisponibles()), filaFont));

            String proveedor = (l.getIdProveedor() != null)
                    ? l.getIdProveedor().getNombre()
                    : "-";
            tabla.addCell(new Phrase(proveedor, filaFont));

            String genero = (l.getIdGenero() != null)
                    ? l.getIdGenero().getNombre()
                    : "-";
            tabla.addCell(new Phrase(genero, filaFont));

            String estado = (l.getActivo() != null && l.getActivo()) ? "Activo" : "Inactivo";
            tabla.addCell(new Phrase(estado, filaFont));
        }

        doc.add(tabla);
        doc.close();
    }

    private String ns(String val) {
        return val == null ? "-" : val;
    }

    private String nsInt(Integer val) {
        return val == null ? "-" : val.toString();
    }
}
