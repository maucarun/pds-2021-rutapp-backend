package com.unsam.pds

import java.util.Properties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
class EmailConfiguration {

	@Bean
	def JavaMailSender getJavaMailSender() {
		var mailSender = new JavaMailSenderImpl()
		mailSender.setHost("smtp.gmail.com")
		mailSender.setPort(587)

		mailSender.setUsername("rutapp.abecam")
		mailSender.setPassword("Abecam21Unsam")

		var Properties props = mailSender.javaMailProperties
		props.put("mail.transport.protocol", "smtp")
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true")
		props.put("mail.debug", "true")
		props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		mailSender
	}

	@Bean
	def SimpleMailMessage emailTemplate() {
		var SimpleMailMessage message = new SimpleMailMessage()
		message.setTo("somebody@gmail.com")
		message.setFrom("admin@gmail.com")
		message.setText("FATAL - Application crash. Save your job !!")
		message
	}
}
