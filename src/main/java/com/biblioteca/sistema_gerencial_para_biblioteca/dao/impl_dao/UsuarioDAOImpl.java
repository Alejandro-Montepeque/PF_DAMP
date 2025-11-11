package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;

import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IUsuarioDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.PasswordUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery; // Usado para consultas con tipo
import java.util.List;

public class UsuarioDAOImpl implements IUsuarioDAO {

    public UsuarioDAOImpl() {
    }

    @Override
    public void crear(Usuario usuario) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // iniciar la transaccion
            em.getTransaction().begin();
            // empujar el objeto
            em.persist(usuario);
            // guardar cambios
            em.getTransaction().commit();
        } catch (Exception e) {
            // si algo falla revertir los cambios
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al crear el usuario: " + e.getMessage(), e);
        } finally {
            // Cerrar siempre el EntityManager
            em.close();
        }
    }

    @Override
    public Usuario obtenerPorId(int idUsuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody

    }

    @Override
    public List<Usuario> obtenerTodos() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody

    }

    @Override
    public void actualizar(Usuario libro) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void eliminar(int idLibro) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean isValidEmail(String email) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean isValidDUI(String dui) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean validateUser(String email, String password) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // 1. Escribes la consulta en JPQL
            // NOTA: "Usuario" es el nombre de la *clase* Java
            // "email" es el nombre del *atributo* en la clase
            String jpql = "SELECT u FROM Usuario u WHERE u.email = :correo";

            // 2. Creas la consulta
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);

            // 3. Asignas el parámetro (evita inyección SQL)
            query.setParameter("correo", email);

            // 4. Ejecutas la consulta y pides un *único resultado*
            // Esto es lo que cambia:
            Usuario usuarioEmail = query.getSingleResult();
            return PasswordUtil.verifyPassword(password, usuarioEmail.getPasswordHash());

        } catch (jakarta.persistence.NoResultException e) {
            // 5. ¡Importante! Si no se encuentra el email, getSingleResult()
            //    lanza una excepción. Debemos capturarla y devolver null.
            return false;
        } finally {
            em.close();
        }

    }

    @Override
    public Usuario obtenerPorEmail(String email) {

        EntityManager em = JPAUtil.getEntityManager();
        try {
            // 1. Escribes la consulta en JPQL
            // NOTA: "Usuario" es el nombre de la *clase* Java
            // "email" es el nombre del *atributo* en la clase
            String jpql = "SELECT u FROM Usuario u WHERE u.email = :correo";

            // 2. Creas la consulta
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);

            // 3. Asignas el parámetro (evita inyección SQL)
            query.setParameter("correo", email);

            // 4. Ejecutas la consulta y pides un *único resultado*
            // Esto es lo que cambia:
            return query.getSingleResult();

        } catch (jakarta.persistence.NoResultException e) {
            // 5. ¡Importante! Si no se encuentra el email, getSingleResult()
            //    lanza una excepción. Debemos capturarla y devolver null.
            return null;

        } finally {
            em.close();
        }

    }
}
