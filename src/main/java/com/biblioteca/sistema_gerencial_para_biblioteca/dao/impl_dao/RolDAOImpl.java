/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.dao.impl_dao;
import com.biblioteca.sistema_gerencial_para_biblioteca.dao.interface_dao.IRolDAO;
import com.biblioteca.sistema_gerencial_para_biblioteca.model.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery; 
import java.util.List;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;

public class RolDAOImpl implements IRolDAO{

    public RolDAOImpl(){}
    
    @Override
    public Role obtenerPorId(Integer idRol) {
           EntityManager em = JPAUtil.getEntityManager();
        try {
           
          Role rol = em.find(Role.class, idRol);
          return rol;
            
        } catch (Exception e) {
            // si algo falla revertir los cambios
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return null;
        } finally {
            // Cerrar siempre el EntityManager
            em.close();
        }
    }
    
}
