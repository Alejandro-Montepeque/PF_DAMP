/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.utils;

/**
 *
 * @author Daniel
 */
public class hashpasswordtemp {
    public static void main(String[] args) {
        // ---- DEFINE TU CONTRASEÑA SECRETA AQUÍ ----
        String claveSecreta = "S3n71n3la";
        
        String hashGenerado = PasswordUtil.hashPassword(claveSecreta);
        
        System.out.println("=============================================================");
        System.out.println("Tu clave es: " + claveSecreta);
        System.out.println("Tu hash BCrypt es: " + hashGenerado);
        System.out.println("¡Copia el hash de arriba y pégalo en tu script SQL!");
        System.out.println("=============================================================");
    }
}
