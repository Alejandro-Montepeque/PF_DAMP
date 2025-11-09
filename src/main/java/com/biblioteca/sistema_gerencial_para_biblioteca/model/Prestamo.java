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
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
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
@Table(name = "prestamos")
@NamedQueries({
    @NamedQuery(name = "Prestamo.findAll", query = "SELECT p FROM Prestamo p")})
public class Prestamo implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_prestamo")
    private Integer idPrestamo;
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha_prestamo")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaPrestamo;
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha_entrega_estimada")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaEntregaEstimada;
    @Column(name = "fecha_entrega_real")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaEntregaReal;
    @Size(max = 2147483647)
    @Column(name = "observaciones")
    private String observaciones;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "estado")
    private String estado;
    @ManyToMany(mappedBy = "prestamoList")
    private List<Libro> libroList;
    @JoinColumn(name = "id_bibliotecario", referencedColumnName = "id_bibliotecario")
    @ManyToOne(optional = false)
    private Bibliotecario idBibliotecario;
    @JoinColumn(name = "id_usuario", referencedColumnName = "id_usuario")
    @ManyToOne(optional = false)
    private Usuario idUsuario;

    public Prestamo() {
    }

    public Prestamo(Integer idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public Prestamo(Integer idPrestamo, Date fechaPrestamo, Date fechaEntregaEstimada, String estado) {
        this.idPrestamo = idPrestamo;
        this.fechaPrestamo = fechaPrestamo;
        this.fechaEntregaEstimada = fechaEntregaEstimada;
        this.estado = estado;
    }

    public Integer getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(Integer idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public Date getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(Date fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public Date getFechaEntregaEstimada() {
        return fechaEntregaEstimada;
    }

    public void setFechaEntregaEstimada(Date fechaEntregaEstimada) {
        this.fechaEntregaEstimada = fechaEntregaEstimada;
    }

    public Date getFechaEntregaReal() {
        return fechaEntregaReal;
    }

    public void setFechaEntregaReal(Date fechaEntregaReal) {
        this.fechaEntregaReal = fechaEntregaReal;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public List<Libro> getLibroList() {
        return libroList;
    }

    public void setLibroList(List<Libro> libroList) {
        this.libroList = libroList;
    }

    public Bibliotecario getIdBibliotecario() {
        return idBibliotecario;
    }

    public void setIdBibliotecario(Bibliotecario idBibliotecario) {
        this.idBibliotecario = idBibliotecario;
    }

    public Usuario getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Usuario idUsuario) {
        this.idUsuario = idUsuario;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idPrestamo != null ? idPrestamo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Prestamo)) {
            return false;
        }
        Prestamo other = (Prestamo) object;
        if ((this.idPrestamo == null && other.idPrestamo != null) || (this.idPrestamo != null && !this.idPrestamo.equals(other.idPrestamo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.biblioteca.sistema_gerencial_para_biblioteca.model.Prestamo[ idPrestamo=" + idPrestamo + " ]";
    }
    
}
