/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.ILibroDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery; // Usado para consultas con tipo
import java.util.List;

public class LibroDAOImpl implements ILibroDAO {
    
    @Override
    public void crear(Libro libro) {
        // 1. Obtener el EntityManager (la "conexión")
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // 2. Iniciar la transacción
            em.getTransaction().begin();
            // 3. Persistir el objeto (esto lo "empuja" a la BD)
            em.persist(libro);
            // 4. Confirmar la transacción (guardar cambios)
            em.getTransaction().commit();
        } catch (Exception e) {
            // 5. Si algo falla, revertir los cambios
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            // 6. ¡MUY IMPORTANTE! Cerrar siempre el EntityManager
            em.close();
        }
    }

    //@Override
    //public Libro obtenerPorId(int idLibro) {
    //    throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    //}
    
    @Override
    public Libro obtenerPorId(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        Libro libro = null;

        try {
            em.getTransaction().begin();
            libro = em.find(Libro.class, id);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
        return libro;
    }


    @Override
    public List<Libro> obtenerTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            
            // JPQL para seleccionar todos los objetos de la clase "Libro"
            String jpql = "SELECT l FROM Libro l";
            TypedQuery<Libro> query = em.createQuery(jpql, Libro.class);
            List<Libro> lista = null;
            lista = query.getResultList();

            return lista;
        } finally {
            em.close();
        }
    }

    @Override
    public void actualizar(Libro libro) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(libro);
            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar el Libro", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void eliminar(int idLibro) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
