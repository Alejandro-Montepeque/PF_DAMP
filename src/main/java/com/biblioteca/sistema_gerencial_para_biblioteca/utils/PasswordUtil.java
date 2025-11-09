/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.biblioteca.sistema_gerencial_para_biblioteca.utils;
import at.favre.lib.crypto.bcrypt.BCrypt;

public class PasswordUtil {
    // nash (Para el registro de usuarios)
    
    public static String hashPassword(String plainTextPassword) {
        
        return BCrypt.withDefaults().hashToString(12, plainTextPassword.toCharArray());
    }

    public static boolean verifyPassword(String plainTextPassword, String storedHash) {

        BCrypt.Result result = BCrypt.verifyer().verify(plainTextPassword.toCharArray(), storedHash);
        
        return result.verified;
    }
}
