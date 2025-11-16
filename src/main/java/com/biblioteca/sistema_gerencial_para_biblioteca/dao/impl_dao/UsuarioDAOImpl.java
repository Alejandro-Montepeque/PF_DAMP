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
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Usuario usuario = em.find(Usuario.class, idUsuario);
            return usuario;

        } finally {
            em.close();
        }
    }

    @Override
    public List<Usuario> obtenerTodos() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // JPQL para seleccionar todos los objetos de la clase "Usuario"
            String jpql = "SELECT u FROM Usuario u JOIN FETCH u.idRol";
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);
            return query.getResultList();
        } finally {
            em.close();
        }

    }

    @Override
    public List<Usuario> obtenerPorRol(int idRol) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // JPQL para seleccionar todos los objetos de la clase "Usuario"
            String jpql = "SELECT u FROM Usuario u JOIN FETCH u.idRol r WHERE r.idRol = :idDelRol";
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);
            query.setParameter("idDelRol", idRol);
            return query.getResultList();
        } finally {
            em.close();
        }

    }

    @Override
    public void actualizar(Usuario usuario) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(usuario);
            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("Error al actualizar el Usuario", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void eliminar(int idUsuario) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean isValidEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT u FROM Usuario u WHERE u.email = :correo";

            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);

            query.setParameter("correo", email);

            Usuario usuarioEmail = query.getSingleResult();
            if (usuarioEmail == null) {
                return true;
            } else {
                return false;
            }

        } catch (jakarta.persistence.NoResultException e) {
            //  lanza una excepcion bebemos capturarla y devolver null
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isValidDUI(String dui) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT u FROM Usuario u WHERE u.dui = :dui";
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);
            query.setParameter("dui", dui);

            query.getSingleResult();
            return false;

        } catch (jakarta.persistence.NoResultException e) {
            return true;

        } finally {
            em.close();
        }
    }

    @Override
    public boolean validateUser(String email, String password) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT u FROM Usuario u WHERE u.email = :correo";
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);
            query.setParameter("correo", email);
            Usuario usuarioEmail = query.getSingleResult();
            return PasswordUtil.verifyPassword(password, usuarioEmail.getPasswordHash());
        } catch (jakarta.persistence.NoResultException e) {
            return false;
        } finally {
            em.close();
        }

    }

    @Override
    public Usuario obtenerPorEmail(String email) {

        EntityManager em = JPAUtil.getEntityManager();
        try {

            String jpql = "SELECT u FROM Usuario u WHERE u.email = :correo";

            // consulta
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);

            // (evita inyección SQL)
            query.setParameter("correo", email);

            return query.getSingleResult();

        } catch (jakarta.persistence.NoResultException e) {

            return null;

        } finally {
            em.close();
        }

    }

    @Override
    public Usuario obtenerPorDui(String DUI) {

        EntityManager em = JPAUtil.getEntityManager();
        try {

            String jpql = "SELECT u FROM Usuario u WHERE u.dui = :dui";

            // consulta
            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);

            // (evita inyección SQL)
            query.setParameter("dui", DUI);

            return query.getSingleResult();

        } catch (jakarta.persistence.NoResultException e) {

            return null;

        } finally {
            em.close();
        }

    }

    @Override
    public List<Usuario> filtrarUsuarios(String campo, String valor, int idRol) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            // Mapeo seguro de campos permitidos (evita SQL Injection)
            String campoJPQL;

            switch (campo) {
                case "nombre":
                    campoJPQL = "u.nombre";
                    break;
                case "dui":
                    campoJPQL = "u.dui";
                    break;
                case "email":
                    campoJPQL = "u.email";
                    break;
                default:
                    campoJPQL = "u.nombre"; // default
            }

            String jpql
                    = "SELECT u FROM Usuario u "
                    + "JOIN FETCH u.idRol r "
                    + "WHERE r.idRol = :idRol "
                    + "AND LOWER(" + campoJPQL + ") LIKE LOWER(:valor)";

            TypedQuery<Usuario> query = em.createQuery(jpql, Usuario.class);
            query.setParameter("idRol", idRol);
            query.setParameter("valor", "%" + valor + "%");

            return query.getResultList();

        } finally {
            em.close();
        }
    }

    @Override
    public List<Usuario> filtrarUsuarios() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Usuario> obtenerUsuariosBasicos() {
        EntityManager em = JPAUtil.getEntityManager();
        List<Usuario> usuarios = null;

        try {
            usuarios = em.createQuery(
                    "SELECT NEW com.biblioteca.sistema_gerencial_para_biblioteca.model.Usuario( "
                    + "u.idUsuario, u.nombre, u.dui, u.email) "
                    + "FROM Usuario u WHERE u.idRol.idRol = 3",
                    Usuario.class
            ).getResultList();
        } finally {
            em.close();
        }

        return usuarios;
    }

}
