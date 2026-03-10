/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Entity;

import java.time.LocalDateTime;

/**
 *
 * @author ASUS
 */
public class Otp {
    private String email;
    private String otp;
    
  
    private boolean isUsed;
    
    private LocalDateTime expiryTime;

    public Otp(String email, String otp, boolean isUsed, LocalDateTime expiryTime) {
        this.email = email;
        this.otp = otp;
        this.isUsed = isUsed;
        this.expiryTime = expiryTime;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    @Override
    public String toString() {
        return "Otp{" + "email=" + email + ", otp=" + otp + ", isUsed=" + isUsed + ", expiryTime=" + expiryTime + '}';
    }
    
    
}
