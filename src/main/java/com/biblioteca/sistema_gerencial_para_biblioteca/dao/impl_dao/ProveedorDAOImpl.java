/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IProveedorDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery; // Usado para consultas con tipo
import java.util.List;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Proveedore;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;

public class ProveedorDAOImpl implements IProveedorDAO {

    @Override
    public void crear(Proveedore proveedor) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(proveedor);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al crear el proveedor", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void actualizar(Proveedore proveedor) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(proveedor);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar el proveedor", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void eliminar(int idProveedor) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Proveedore proveedor = em.find(Proveedore.class, idProveedor);
            if (proveedor != null) {
                em.remove(proveedor);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();

            throw new RuntimeException("Error al eliminar el proveedor", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Proveedore obtenerPorId(int idProveedor) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Proveedore.class, idProveedor);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Proveedore> obtenerTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Proveedore p";
            TypedQuery<Proveedore> query = em.createQuery(jpql, Proveedore.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Proveedore> buscarPorNombreOTipo(String texto) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT p FROM Proveedore p WHERE p.nombre LIKE :texto OR p.tipo LIKE :texto";
            TypedQuery<Proveedore> query = em.createQuery(jpql, Proveedore.class);
            query.setParameter("texto", "%" + texto + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Proveedore> findActivos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Proveedore p ORDER BY p.idProveedor", Proveedore.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Proveedore> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Proveedore p WHERE p.activo = true ORDER BY p.nombre", Proveedore.class)
                    .getResultList();
        } finally {
            em.close();
        }

    }
}
