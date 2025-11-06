/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.model;
import com.biblioteca.sistema_gerencial_para_biblioteca.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

public class Usuario {
    public boolean checkConnection()
    {
    EntityManager em = JPAUtil.getEntityManager();
    return em.isOpen();
    }
}
