/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import java.util.List;

public interface IProveedorDAO {
        // --- CRUD Básico ---
    void crear(Proveedore proveedor);
    void actualizar(Proveedore proveedor);
    void eliminar(int idProveedor);
    Proveedore obtenerPorId(int idProveedor);
    List<Proveedore> obtenerTodos();
    
    // --- Lógica de Filtros ---
    List<Proveedore> buscarPorNombreOTipo(String texto);
}
