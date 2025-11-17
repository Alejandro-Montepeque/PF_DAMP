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
        String claveSecreta = "S3n71n3la";
        String hashGenerado = PasswordUtil.hashPassword(claveSecreta);    
        System.out.println("clave es: " + claveSecreta);
        System.out.println("hash BCrypt es: " + hashGenerado);
    }
}
