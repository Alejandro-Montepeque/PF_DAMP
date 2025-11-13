/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
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
@Table(name = "usuarios")
@NamedQueries({
    @NamedQuery(name = "Usuario.findAll", query = "SELECT u FROM Usuario u")})
public class Usuario implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_usuario")
    private Integer idUsuario;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "nombre")
    private String nombre;
    @Column(name = "fecha_nacimiento")
    @Temporal(TemporalType.DATE)
    private Date fechaNacimiento;
    @Size(max = 500)
    @Column(name = "direccion")
    private String direccion;
    @Size(max = 25)
    @Column(name = "sexo")
    private String sexo;
    @Size(max = 20)
    @Column(name = "telefono")
    private String telefono;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "dui")
    private String dui;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "email")
    private String email;
    @Size(min = 1, max = 256)
    @Column(name = "password_hash")
    private String passwordHash;
    @Basic(optional = false)
    @NotNull
    @Column(name = "activo")
    private boolean activo;
    @Size(max = 100)
    @Column(name = "tipo_usuario")
    private String tipoUsuario;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "idUsuario")
    private Bibliotecario bibliotecario;
    @ManyToOne(optional = false)
    @JoinColumn(name = "id_rol")
    private Role idRol;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "idUsuario")
    private List<Prestamo> prestamoList;

    public Usuario() {
    }

    public Usuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Usuario(Integer idUsuario, String nombre, String dui, String email, String passwordHash, boolean activo) {
        this.idUsuario = idUsuario;
        this.nombre = nombre;
        this.dui = dui;
        this.email = email;
        this.passwordHash = passwordHash;
        this.activo = activo;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDui() {
        return dui;
    }

    public void setDui(String dui) {
        this.dui = dui;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public boolean getActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getTipoUsuario() {
        return tipoUsuario;
    }

    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public Bibliotecario getBibliotecario() {
        return bibliotecario;
    }

    public void setBibliotecario(Bibliotecario bibliotecario) {
        this.bibliotecario = bibliotecario;
    }


    public Role getIdRol() {
        return idRol;
    }

    public void setIdRol(Role idRol) {
        this.idRol = idRol;
    }

    public List<Prestamo> getPrestamoList() {
        return prestamoList;
    }

    public void setPrestamoList(List<Prestamo> prestamoList) {
        this.prestamoList = prestamoList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idUsuario != null ? idUsuario.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Usuario)) {
            return false;
        }
        Usuario other = (Usuario) object;
        if ((this.idUsuario == null && other.idUsuario != null) || (this.idUsuario != null && !this.idUsuario.equals(other.idUsuario))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario[ idUsuario=" + idUsuario + " ]";
    }
    
}
