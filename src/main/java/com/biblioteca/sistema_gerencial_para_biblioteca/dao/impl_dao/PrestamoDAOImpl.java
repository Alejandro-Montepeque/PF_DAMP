/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IPrestamoDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Prestamo;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.DetallePrestamo;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Libro;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

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
            
    // PrestamoDAOImpl.java
    @Override
    public void crear(Prestamo p)  {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            // Asegurarnos de que la lista no sea null
            List<DetallePrestamo> detalles = p.getDetallePrestamoList();
            if (detalles == null) {
                detalles = new ArrayList<>();
                p.setDetallePrestamoList(detalles);
            }

            // Reemplazar referencias a Libro por entidades gestionadas por este EM
            List<DetallePrestamo> detallesParaPersistir = new ArrayList<>();
            for (DetallePrestamo dp : detalles) {
                if (dp == null) continue;

                // obtener el id del libro (asumimos que dp.getLibro() no es null)
                Libro libroRef = dp.getLibro();
                if (libroRef != null && libroRef.getIdLibro() != null) {
                    Libro libroManaged = em.find(Libro.class, libroRef.getIdLibro());
                    dp.setLibro(libroManaged);
                } else {
                    // si no hay id de libro, lanzamos excepción porque no tiene sentido
                    throw new IllegalArgumentException("Cada detalle debe referenciar un libro existente (id_libro).");
                }

                // El prestamo aún no está persistido; seteamos la referencia local (se actualizará después)
                dp.setPrestamo(p);

                detallesParaPersistir.add(dp);
            }

            // Re-assign list por si se modificó
            p.setDetallePrestamoList(detallesParaPersistir);

            // Persistir préstamo (cascade persistará los detalles)
            em.persist(p);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
            throw new RuntimeException("Error al crear el préstamo: " + e.getMessage(), e);
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
    
    @Override
    public void actualizar(Prestamo p) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            // Recuperar estado persistente actual (si existe)
            Prestamo managedPrestamo = (p.getIdPrestamo() != null) ? em.find(Prestamo.class, p.getIdPrestamo()) : null;

            if (managedPrestamo == null) {
                // Si no existe, delegamos a crear (o lanzar error según tu modelo)
                em.getTransaction().commit();
                em.close();
                crear(p);
                return;
            }

            // Preparar lista de detalles nueva: re-adjuntar libros a este EM
            List<DetallePrestamo> nuevosDetalles = p.getDetallePrestamoList();
            if (nuevosDetalles == null) nuevosDetalles = new ArrayList<>();

            List<DetallePrestamo> detallesParaPersistir = new ArrayList<>();
            for (DetallePrestamo dp : nuevosDetalles) {
                if (dp == null) continue;

                Libro libroRef = dp.getLibro();
                if (libroRef != null && libroRef.getIdLibro() != null) {
                    Libro libroManaged = em.find(Libro.class, libroRef.getIdLibro());
                    dp.setLibro(libroManaged);
                } else {
                    throw new IllegalArgumentException("Cada detalle debe referenciar un libro existente (id_libro).");
                }

                // conectar el detalle al prestamo gestionado
                dp.setPrestamo(managedPrestamo);

                detallesParaPersistir.add(dp);
            }

            // Reemplazar la lista de detalles en el objeto que vamos a mergear
            managedPrestamo.setDetallePrestamoList(detallesParaPersistir);

            // Actualizar campos simple del préstamo
            managedPrestamo.setFechaPrestamo(p.getFechaPrestamo());
            managedPrestamo.setFechaEntregaEstimada(p.getFechaEntregaEstimada());
            managedPrestamo.setFechaEntregaReal(p.getFechaEntregaReal());
            managedPrestamo.setObservaciones(p.getObservaciones());
            managedPrestamo.setEstado(p.getEstado());
            managedPrestamo.setIdUsuario(p.getIdUsuario());
            managedPrestamo.setIdBibliotecario(p.getIdBibliotecario());

            // merge (aunque managedPrestamo ya es managed, merge es redundante; dejamos para seguridad)
            em.merge(managedPrestamo);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar el préstamo: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Prestamo obtenerPorId(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Traer con detalles y libros para evitar problemas lazy
            TypedQuery<Prestamo> q = em.createQuery(
                    "SELECT DISTINCT p FROM Prestamo p " +
                    "LEFT JOIN FETCH p.detallePrestamoList d " +
                    "LEFT JOIN FETCH d.libro " +
                    "LEFT JOIN FETCH p.idUsuario " +
                    "LEFT JOIN FETCH p.idBibliotecario " +
                    "WHERE p.idPrestamo = :id",
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
            // Trae prestamos con detalles y libros asociados
            String jpql = "SELECT DISTINCT p FROM Prestamo p " +
                          "LEFT JOIN FETCH p.detallePrestamoList d " +
                          "LEFT JOIN FETCH d.libro " +
                          "LEFT JOIN FETCH p.idUsuario " +
                          "LEFT JOIN FETCH p.idBibliotecario " +
                          "ORDER BY p.fechaPrestamo DESC";
            TypedQuery<Prestamo> query = em.createQuery(jpql, Prestamo.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
}
