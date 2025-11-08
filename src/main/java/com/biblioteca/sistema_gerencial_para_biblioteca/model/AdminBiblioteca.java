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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Daniel
 */
@Entity
@Table(name = "admin_biblioteca")
@NamedQueries({
    @NamedQuery(name = "AdminBiblioteca.findAll", query = "SELECT a FROM AdminBiblioteca a")})
public class AdminBiblioteca implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_bibliotecario")
    private Integer idBibliotecario;
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha_ingreso")
    @Temporal(TemporalType.DATE)
    private Date fechaIngreso;
    @JoinColumn(name = "id_usuario", referencedColumnName = "id_usuario")
    @OneToOne(optional = false)
    private Usuario idUsuario;

    public AdminBiblioteca() {
    }

    public AdminBiblioteca(Integer idBibliotecario) {
        this.idBibliotecario = idBibliotecario;
    }

    public AdminBiblioteca(Integer idBibliotecario, Date fechaIngreso) {
        this.idBibliotecario = idBibliotecario;
        this.fechaIngreso = fechaIngreso;
    }

    public Integer getIdBibliotecario() {
        return idBibliotecario;
    }

    public void setIdBibliotecario(Integer idBibliotecario) {
        this.idBibliotecario = idBibliotecario;
    }

    public Date getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(Date fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
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
        hash += (idBibliotecario != null ? idBibliotecario.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AdminBiblioteca)) {
            return false;
        }
        AdminBiblioteca other = (AdminBiblioteca) object;
        if ((this.idBibliotecario == null && other.idBibliotecario != null) || (this.idBibliotecario != null && !this.idBibliotecario.equals(other.idBibliotecario))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.biblioteca.sistema_gerencial_para_biblioteca.model.AdminBiblioteca[ idBibliotecario=" + idBibliotecario + " ]";
    }
    
}
