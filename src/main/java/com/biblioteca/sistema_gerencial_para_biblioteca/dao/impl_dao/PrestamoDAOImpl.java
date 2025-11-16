/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;
import jakarta.persistence.EntityManager;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;


public class PrestamoDAOImpl implements IPrestamoDAO {
    
    @Override
    public int contarDevolucionesATiempo(){
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Prestamo p WHERE p.fechaEntregaReal <= p.fechaEntregaEstimada";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }
    
    @Override
    public int contarDevolucionesAtrasadas() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Prestamo p WHERE p.fechaEntregaReal > p.fechaEntregaEstimada";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }
    
}
