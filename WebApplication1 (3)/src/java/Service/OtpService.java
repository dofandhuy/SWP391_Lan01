/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import java.util.Properties;
import java.util.Random;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author ASUS
 */
public class OtpService {
    

    // THAY THẾ THÔNG TIN CỦA BẠN VÀO ĐÂY
    private static final String FROM_EMAIL = "ducloc0912@gmail.com"; // Email của bạn
    private static final String PASSWORD = "pefd ooky crbe puvi";      // Mật khẩu ứng dụng Google

    /**
     * Tạo mã OTP ngẫu nhiên gồm 6 chữ số
     * @return String OTP
     */
    public String generateOtp() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    /**
     * Gửi email chứa mã OTP
     * @param toEmail Email người nhận
     * @param otp Mã OTP
     */
    public void sendOtpEmail(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("E-LMS Admin Login Verification Code");
            message.setText("Dear Admin,\n\nYour One-Time Password (OTP) is: " + otp + "\n\nThis code is valid for 10 minutes.\n\nBest regards,\nE-LMS Team");

            Transport.send(message);
            System.out.println("OTP email sent successfully to " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}

