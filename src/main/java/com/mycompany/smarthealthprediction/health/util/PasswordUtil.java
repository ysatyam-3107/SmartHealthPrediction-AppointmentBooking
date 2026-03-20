package com.mycompany.smarthealthprediction.health.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    
    private static final int WORK_FACTOR = 12;
    
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }
    
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
    
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        return hasDigit && hasLetter;
    }
}