/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao;

import com.biblioteca.sistema_gerencial_para_biblioteca.model.Prestamo;
import java.util.List;

public interface IPrestamoDAO {

    int contarDevolucionesATiempo();

    int contarDevolucionesAtrasadas();

    void crear(Prestamo prestamo) throws Exception;

    void actualizar(Prestamo prestamo) throws Exception;

    Prestamo obtenerPorId(int idPrestamo);

    List<Prestamo> listar();

}
