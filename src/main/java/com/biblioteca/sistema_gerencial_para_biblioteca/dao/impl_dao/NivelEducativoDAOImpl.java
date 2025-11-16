/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.INivelEducativoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.NivelesEducativo;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;


public class NivelEducativoDAOImpl implements INivelEducativoDAO {
    @Override
    public List<NivelesEducativo> obtenerTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        List<NivelesEducativo> niveles = null;
        try {
             // Usa el NamedQuery definido en la entidad Nivel Educativo
            TypedQuery<NivelesEducativo> query = em.createNamedQuery("NivelesEducativo.findAll", NivelesEducativo.class);
            niveles = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return niveles;
    }
}