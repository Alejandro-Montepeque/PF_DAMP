/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import java.util.List;

public interface IProveedorDAO {
     
    void crear(Proveedore proveedor);
    void actualizar(Proveedore proveedor);
    void eliminar(int idProveedor);
    Proveedore obtenerPorId(int idProveedor);
    List<Proveedore> obtenerTodos();
    List<Proveedore> findActivos();
    List<Proveedore> findAll();
    List<Proveedore> buscarPorNombreOTipo(String texto);
}
