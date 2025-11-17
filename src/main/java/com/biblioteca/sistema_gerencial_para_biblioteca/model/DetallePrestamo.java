package com.biblioteca.sistema_gerencial_para_biblioteca.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "detalle_prestamo")
public class DetallePrestamo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_detalle_prestamo")
    private Integer idDetallePrestamo;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_prestamo", referencedColumnName = "id_prestamo")
    private Prestamo prestamo;

    @ManyToOne(optional = false)
    @JoinColumn(name = "id_libro", referencedColumnName = "id_libro")
    private Libro libro;

    public DetallePrestamo() {}

    public Integer getIdDetallePrestamo() {
        return idDetallePrestamo;
    }

    public void setIdDetallePrestamo(Integer idDetallePrestamo) {
        this.idDetallePrestamo = idDetallePrestamo;
    }

    public Prestamo getPrestamo() {
        return prestamo;
    }

    public void setPrestamo(Prestamo prestamo) {
        this.prestamo = prestamo;
    }

    public Libro getLibro() {
        return libro;
    }

    public void setLibro(Libro libro) {
        this.libro = libro;
    }
}
