/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Prestamo;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAOImpl implements IPrestamoDAO {

    @Override
    public int contarDevolucionesATiempo() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Prestamo p WHERE p.fechaEntregaReal <= p.fechaEntregaEstimada";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

    // PrestamoDAOImpl.java
    @Override
    public void crear(Prestamo prestamo) throws Exception {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            em.getTransaction().begin();

            em.getTransaction().begin();

            Libro libro = em.find(Libro.class, prestamo.getIdLibro().getIdLibro());
            if (libro == null) {
                throw new Exception("El libro seleccionado no existe.");
            }

            if (libro.getActivo() == null || !libro.getActivo()) {
                throw new Exception("El libro está inactivo y no puede prestarse.");
            }

            if (libro.getCantDisponibles() <= 0) {
                throw new Exception("No hay copias disponibles del libro: " + libro.getTitulo());
            }

            libro.setCantDisponibles(libro.getCantDisponibles() - 1);
            em.persist(prestamo);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al registrar el prestamo " + e.getMessage(), e);
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

    /*  @Override
    public void actualizar(Prestamo p) throws Exception {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            em.getTransaction().begin();

            Prestamo managed = em.find(Prestamo.class, p.getIdPrestamo());
            if (managed == null) {
                throw new Exception("El préstamo no existe.");
            }

            managed.setIdUsuario(p.getIdUsuario());
            managed.setIdLibro(p.getIdLibro());
            managed.setFechaPrestamo(p.getFechaPrestamo());
            managed.setFechaEntregaEstimada(p.getFechaEntregaEstimada());
            managed.setFechaEntregaReal(p.getFechaEntregaReal());
            managed.setObservaciones(p.getObservaciones());
            managed.setEstado(p.getEstado());

            em.merge(managed);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
     */
    @Override
    public void actualizar(Prestamo p) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            em.getTransaction().begin();

            Prestamo old = em.find(Prestamo.class, p.getIdPrestamo());
            if (old == null) {
                throw new RuntimeException("Préstamo no encontrado.");
            }

            Libro oldLibro = em.find(Libro.class, old.getIdLibro().getIdLibro());
            Libro newLibro = em.find(Libro.class, p.getIdLibro().getIdLibro());

            // ============= 1. LIBRO CAMBIÓ =============
            if (!oldLibro.getIdLibro().equals(newLibro.getIdLibro())) {

                // devolver stock al libro antiguo si estaba prestado
                if (old.getEstado().equals("Pendiente")) {
                    oldLibro.setCantDisponibles(oldLibro.getCantDisponibles() + 1);
                    em.merge(oldLibro);
                }

                // ahora validar stock del nuevo libro
                if (newLibro.getCantDisponibles() <= 0) {
                    throw new RuntimeException("El libro nuevo no tiene copias disponibles.");
                }

                // descontar stock del nuevo libro
                newLibro.setCantDisponibles(newLibro.getCantDisponibles() - 1);
                em.merge(newLibro);
            }

            // ============= 2. ESTADO CAMBIÓ =============
            if (!old.getEstado().equals(p.getEstado())) {

                // Pendiente → Entregado  (se devuelve el libro)
                if (old.getEstado().equals("Pendiente") && p.getEstado().equals("Entregado")) {
                    newLibro.setCantDisponibles(newLibro.getCantDisponibles() + 1);
                    em.merge(newLibro);
                }

                // Entregado → Pendiente  (se lo lleva otra vez)
                if (old.getEstado().equals("Entregado") && p.getEstado().equals("Pendiente")) {

                    if (newLibro.getCantDisponibles() <= 0) {
                        throw new RuntimeException("No hay unidades disponibles para marcar como pendiente.");
                    }

                    newLibro.setCantDisponibles(newLibro.getCantDisponibles() - 1);
                    em.merge(newLibro);
                }
            }

            // ============= 3. ACTUALIZAR REGISTRO =============
            old.setFechaPrestamo(p.getFechaPrestamo());
            old.setFechaEntregaEstimada(p.getFechaEntregaEstimada());
            old.setFechaEntregaReal(p.getFechaEntregaReal());
            old.setIdUsuario(p.getIdUsuario());
            old.setIdBibliotecario(p.getIdBibliotecario());
            old.setIdLibro(newLibro);
            old.setObservaciones(p.getObservaciones());
            old.setEstado(p.getEstado());

            em.merge(old);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error al actualizar préstamo: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Prestamo obtenerPorId(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Traemos el préstamo con usuario, libro y bibliotecario para evitar LazyInitializationException
            TypedQuery<Prestamo> q = em.createQuery(
                    "SELECT DISTINCT p FROM Prestamo p "
                    + "LEFT JOIN FETCH p.idUsuario "
                    + "LEFT JOIN FETCH p.idBibliotecario "
                    + "LEFT JOIN FETCH p.idLibro "
                    + "WHERE p.idPrestamo = :id",
                    Prestamo.class);
            q.setParameter("id", id);
            return q.getResultStream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Prestamo> listar() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Trae prestamos con usuario, libro y bibliotecario asociados
            String jpql = "SELECT DISTINCT p FROM Prestamo p "
                    + "LEFT JOIN FETCH p.idUsuario "
                    + "LEFT JOIN FETCH p.idLibro "
                    + "LEFT JOIN FETCH p.idBibliotecario "
                    + "ORDER BY p.fechaPrestamo DESC";
            TypedQuery<Prestamo> query = em.createQuery(jpql, Prestamo.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public int obtenerPendientes() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Prestamo p WHERE p.estado = 'Pendiente'";
            Long count = em.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } finally {
            em.close();
        }
    }

}
