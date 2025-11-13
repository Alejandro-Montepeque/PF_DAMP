/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;


import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IGeneroDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Genero;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class GeneroDAOImpl implements IGeneroDAO {
    @Override
    public List<Genero> obtenerTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        List<Genero> generos = null;
        try {
             // Usa el NamedQuery definido en la entidad Genero
            TypedQuery<Genero> query = em.createNamedQuery("Genero.findAll", Genero.class);
            generos = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return generos;
    }
}
