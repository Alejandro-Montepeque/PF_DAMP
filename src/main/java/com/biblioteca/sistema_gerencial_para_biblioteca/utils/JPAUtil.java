/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
   // 1. Nombre de la Persistence Unit (de tu persistence.xml)
    private static final String PERSISTENCE_UNIT_NAME = "BibliotecaPU";
    
    // 2. El "Singleton" del Factory (costoso de crear, se crea solo una vez)
    private static EntityManagerFactory emf;

    // 3. Método para obtener el "volante" (el EntityManager)
    public static EntityManager getEntityManager() {
        if (emf == null) {
            // Crea el factory usando el nombre de tu persistence.xml
            emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        }
        // Devuelve un nuevo EntityManager (ligero, se crea por cada transacción)
        return emf.createEntityManager();
    }

    // 4. (Opcional) Método para cerrar todo al apagar la app
    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    } 
}
