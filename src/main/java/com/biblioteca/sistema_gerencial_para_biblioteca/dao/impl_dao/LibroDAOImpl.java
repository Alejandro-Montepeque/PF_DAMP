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
    public Libro obtenerPorTitulo(String titulo) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT l FROM Libro l WHERE l.titulo = :titulo", Libro.class)
                    .setParameter("titulo", titulo)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);
        } finally {
            em.close();
        }
    }

    @Override
    public void eliminar(int idLibro) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int obtenerTotal() {
        EntityManager em = JPAUtil.getEntityManager();
        try {

            String jpql = "Select count(l) from Libro l";

            // consulta
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);

            Long count = query.getSingleResult();
            return count.intValue();

        } catch (jakarta.persistence.NoResultException e) {
            e.printStackTrace();
            return -1;

        } finally {
            em.close();
        }
    }

    @Override
    public int contarLibrosDisponibles() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(1) FROM Libro l WHERE l.activo = true";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

    @Override
    public int contarLibrosPrestados() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(1) FROM Libro l WHERE l.activo = false";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> obtenerConteoLibrosPorGenero() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            String jpql
                    = "SELECT g.nombre, COUNT(l.idLibro) FROM Libro l JOIN l.idGenero g GROUP BY g.nombre ORDER BY COUNT(l.idLibro) DESC";

            return em.createQuery(jpql, Object[].class).getResultList();

        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Libro> filtrarLibros(Integer idGenero, String textoBusqueda) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            // Construir la consulta base
            StringBuilder jpql = new StringBuilder(
                "SELECT l FROM Libro l " +
                "LEFT JOIN FETCH l.idGenero " +
                "LEFT JOIN FETCH l.idNivelEducativo " +
                "LEFT JOIN FETCH l.idProveedor " +
                "WHERE 1=1"
            );

            // Agregar filtro de género si se proporciona
            if (idGenero != null && idGenero > 0) {
                jpql.append(" AND l.idGenero.idGenero = :idGenero");
            }

            // Agregar filtro de búsqueda si se proporciona
            if (textoBusqueda != null && !textoBusqueda.trim().isEmpty()) {
                jpql.append(" AND (LOWER(l.titulo) LIKE LOWER(:texto) OR LOWER(l.autor) LIKE LOWER(:texto))");
            }

            // Ordenar por título
            jpql.append(" ORDER BY l.titulo ASC");

            // Crear la consulta
            TypedQuery<Libro> query = em.createQuery(jpql.toString(), Libro.class);

            // Establecer parámetros si fueron agregados
            if (idGenero != null && idGenero > 0) {
                query.setParameter("idGenero", idGenero);
            }

            if (textoBusqueda != null && !textoBusqueda.trim().isEmpty()) {
                query.setParameter("texto", "%" + textoBusqueda.trim() + "%");
            }

            return query.getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error al filtrar libros: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

}
