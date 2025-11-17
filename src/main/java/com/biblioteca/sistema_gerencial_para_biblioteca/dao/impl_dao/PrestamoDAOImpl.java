/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;
import jakarta.persistence.EntityManager;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Prestamo;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class PrestamoDAOImpl implements IPrestamoDAO {
    
    @Override
    public int contarDevolucionesATiempo(){
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Prestamo p WHERE p.fechaEntregaReal <= p.fechaEntregaEstimada";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();

    // PrestamoDAOImpl.java
    @Override
    public void crear(Prestamo p) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(p);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al crear el préstamo: " + e.getMessage());
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

    @Override
    public void actualizar(Prestamo p) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(p);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar el préstamo: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public Prestamo obtenerPorId(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        Prestamo p = em.find(Prestamo.class, id);
        em.close();
        return p;
    }

    @Override
    public List<Prestamo> listar() {
        EntityManager em = JPAUtil.getEntityManager();
       
        try {
            String jpql = "SELECT p FROM Prestamo p";
            TypedQuery<Prestamo> query = em.createQuery(jpql, Prestamo.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
}
