/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao;
import java.util.List;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;

public interface IUsuarioDAO {
    void crear(Usuario usuario);
    
    Usuario obtenerPorId(int idUsuario);
    
    Usuario obtenerPorEmail(String email);
    
    List<Usuario> obtenerTodos();
    
    void actualizar(Usuario libro);
    
    void eliminar(int idLibro);
    
    boolean isValidEmail(String email);
    
    boolean isValidDUI(String dui);
    
    boolean validateUser(String email, String password);
    
}
