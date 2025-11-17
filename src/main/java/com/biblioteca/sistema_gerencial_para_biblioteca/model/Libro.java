/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Daniel
 */
@Entity
@Table(name = "libros")
@NamedQueries({
    @NamedQuery(name = "Libro.findAll", query = "SELECT l FROM Libro l")})
public class Libro implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_libro")
    private Integer idLibro;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 500)
    @Column(name = "titulo")
    private String titulo;
    @Column(name = "anio_publicacion")
    private Integer anioPublicacion;
    @Size(max = 50)
    @Column(name = "idioma")
    private String idioma;
    @Size(max = 13)
    @Column(name = "isbn")
    private String isbn;
    @Column(name = "num_paginas")
    private Integer numPaginas;
    @Basic(optional = false)
    @NotNull
    @Column(name = "cant_disponibles")
    private int cantDisponibles;
    @Column(name = "fecha_adquisicion")
    @Temporal(TemporalType.DATE)
    private Date fechaAdquisicion;
    @Column(name = "fecha_disponible")
    @Temporal(TemporalType.DATE)
    private Date fechaDisponible;
    @Size(max = 500)
    @Column(name = "imagen_portada")
    private String imagenPortada;
    @ManyToMany(mappedBy = "libroList")
    private List<Autore> autoreList;
    @JoinColumn(name = "id_genero", referencedColumnName = "id_genero")
    @ManyToOne
    private Genero idGenero;
    @JoinColumn(name = "id_nivel_educativo", referencedColumnName = "id_nivel")
    @ManyToOne
    private NivelesEducativo idNivelEducativo;
    @JoinColumn(name = "id_proveedor", referencedColumnName = "id_proveedor")
    @ManyToOne
    private Proveedore idProveedor;

    @Column(name = "activo")
    private Boolean activo;

    @OneToMany(mappedBy = "idLibro")
    private List<Prestamo> prestamoList;

    public Libro() {
    }

    public Libro(Integer idLibro) {
        this.idLibro = idLibro;
    }

    public Libro(Integer idLibro, String titulo, int cantDisponibles, boolean soloConsulta) {
        this.idLibro = idLibro;
        this.titulo = titulo;
        this.cantDisponibles = cantDisponibles;
    }

    public List<Prestamo> getPrestamoList() {
        return prestamoList;
    }

    public void setPrestamoList(List<Prestamo> prestamoList) {
        this.prestamoList = prestamoList;
    }

    public Integer getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(Integer idLibro) {
        this.idLibro = idLibro;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Integer getAnioPublicacion() {
        return anioPublicacion;
    }

    public void setAnioPublicacion(Integer anioPublicacion) {
        this.anioPublicacion = anioPublicacion;
    }

    public String getIdioma() {
        return idioma;
    }

    public void setIdioma(String idioma) {
        this.idioma = idioma;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public Integer getNumPaginas() {
        return numPaginas;
    }

    public void setNumPaginas(Integer numPaginas) {
        this.numPaginas = numPaginas;
    }

    public int getCantDisponibles() {
        return cantDisponibles;
    }

    public void setCantDisponibles(int cantDisponibles) {
        this.cantDisponibles = cantDisponibles;
    }

    public Date getFechaAdquisicion() {
        return fechaAdquisicion;
    }

    public void setFechaAdquisicion(Date fechaAdquisicion) {
        this.fechaAdquisicion = fechaAdquisicion;
    }

    public Date getFechaDisponible() {
        return fechaDisponible;
    }

    public void setFechaDisponible(Date fechaDisponible) {
        this.fechaDisponible = fechaDisponible;
    }

    public String getImagenPortada() {
        return imagenPortada;
    }

    public void setImagenPortada(String imagenPortada) {
        this.imagenPortada = imagenPortada;
    }

    public List<Autore> getAutoreList() {
        return autoreList;
    }

    public void setAutoreList(List<Autore> autoreList) {
        this.autoreList = autoreList;
    }

    public Genero getIdGenero() {
        return idGenero;
    }

    public void setIdGenero(Genero idGenero) {
        this.idGenero = idGenero;
    }

    public NivelesEducativo getIdNivelEducativo() {
        return idNivelEducativo;
    }

    public void setIdNivelEducativo(NivelesEducativo idNivelEducativo) {
        this.idNivelEducativo = idNivelEducativo;
    }

    public Proveedore getIdProveedor() {
        return idProveedor;
    }

    public void setIdProveedor(Proveedore idProveedor) {
        this.idProveedor = idProveedor;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idLibro != null ? idLibro.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Libro)) {
            return false;
        }
        Libro other = (Libro) object;
        if ((this.idLibro == null && other.idLibro != null) || (this.idLibro != null && !this.idLibro.equals(other.idLibro))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro[ idLibro=" + idLibro + " ]";
    }

}
