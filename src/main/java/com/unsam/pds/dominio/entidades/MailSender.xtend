package com.unsam.pds.dominio.entidades

import com.unsam.pds.EmailConfiguration
import java.io.ByteArrayOutputStream
import java.time.format.DateTimeFormatter
import javax.activation.DataHandler
import javax.activation.DataSource
import javax.mail.internet.MimeBodyPart
import javax.mail.internet.MimeMessage
import javax.mail.util.ByteArrayDataSource
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Component

@Component
@Accessors
class MailSender {

	@Autowired
	JavaMailSender emailSender;
	@Autowired
	SimpleMailMessage preConfiguredMessage;

	Usuario usr
	Remito rto

	def void sendSimpleMessage() {
		try {
			println("Se comieza el envio")
			var String to = "rutapp.abecam@gmail.com"
			var String subject = "Envio de remito"
			var String text = "Esto es una prueba"
			var SimpleMailMessage message = new SimpleMailMessage()
			message.setFrom("rutapp.abecam@gmail.com")
			message.setTo(to)
			message.setSubject(subject)
			message.setText(text)
			var sender = new EmailConfiguration().javaMailSender
			sender.send(message)
			println("Finaliza el envio")
		} catch (Exception ex) {
			println("Error")
			ex.printStackTrace()
		}
	}
	
	def void sendEmail(String destinatario, String asunto, String texto) {
		try {
			println("Se comieza el envio")
			var String to = destinatario//"rutapp.abecam@gmail.com"
			var String subject = asunto//"Envio de remito"
			var String text = texto//"Esto es una prueba"
			var SimpleMailMessage message = new SimpleMailMessage()
			message.setFrom("rutapp.abecam@gmail.com")
			message.setTo(to)
			message.setSubject(subject)
			message.setText(text)
			var sender = new EmailConfiguration().javaMailSender
			sender.send(message)
			println("Finaliza el envio")
		} catch (Exception ex) {
			println("Error")
			ex.printStackTrace()
		}
	}

	def sendPdfMail(Remito rto, Usuario usr, String dirLogo) {
		println("Se comieza el envio")
		var String to = rto.cliente.contactos.get(0).emails.get(0).direccion
		var String subject = "Envio de Remito N°" + rto.idRemito
		var String text = getTextMessage(rto, usr)
		var sender = new EmailConfiguration().javaMailSender

		var MimeMessage message = sender.createMimeMessage();
		var MimeMessageHelper helper = new MimeMessageHelper(message, true);
		helper.setFrom(usr.email);
		helper.setTo(to);
		helper.setSubject(subject);
		helper.setText(text);

		var ByteArrayOutputStream outputStream = null

		try {
			var PdfRemito pdfRto = new PdfRemito() => [
				usuario = usr
				remito = rto
				urlLogo = dirLogo
			]

			outputStream = pdfRto.createPdf()
			var byte[] bytes = outputStream.toByteArray
			var DataSource dataSource = new ByteArrayDataSource(bytes, "application/pdf")
			var MimeBodyPart pdfBodyPart = new MimeBodyPart()
			pdfBodyPart.setDataHandler(new DataHandler(dataSource))
			pdfBodyPart.setFileName("Remito.pdf")
			helper.addAttachment("Remito " + rto.idRemito + ".pdf", dataSource)
			sender.send(message)
		} catch (Exception ex) {
			ex.printStackTrace()
		} finally {
			if (null !== outputStream) {
				try {
					outputStream.close()
					outputStream = null
				} catch (Exception ex) {
				}
			}

		}
	}
	
	def sendComprobante(Remito rto, Usuario usr) {
		println("Se comieza el envio")
		var String to = rto.cliente.contactos.get(0).emails.get(0).direccion
		var String subject = "Comprobante de Entrega - Remito N°" + rto.idRemito
		var String text = getTextMessage(rto, usr)
		var sender = new EmailConfiguration().javaMailSender

		var MimeMessage message = sender.createMimeMessage();
		var MimeMessageHelper helper = new MimeMessageHelper(message, true);
		helper.setFrom(usr.email);
		helper.setTo(to);
		helper.setSubject(subject);
		helper.setText(text);

		var ByteArrayOutputStream outputStream = null

		try {
			sender.send(message)
		} catch (Exception ex) {
			ex.printStackTrace()
		} finally {
			if (null !== outputStream) {
				try {
					outputStream.close()
					outputStream = null
				} catch (Exception ex) {
				}
			}

		}
	}

	def String getTextMessage(Remito rto, Usuario usr) {
		var mje = "Hola, " + rto.cliente.nombre + ":\n\n" 
		
		if (rto.comprobante === null) {
			mje +=
			"Tengo el agrado de dirigirme a ud. a fin de hacerle entrega del " + "remito nro. " + rto.idRemito +
			", el cual se adjunta al " + "presente.\n"

			if (rto.productosDelRemito.length > 0) {
				mje += "El mismo corresponde a su pedido de: \n"

				for (ProductoRemito pr : rto.productosDelRemito) {
					mje += "\t* " + pr.cantidad + " unidades de " + pr.producto.nombre + ".\n"
				}

				mje += "\n"
			}
		}

		if (rto.comprobante !== null) {
			mje +=
				"Me complace informarle que el pedido que forma parte del remito nro. " + rto.idRemito + " fue entregado el " +
					rto.comprobante.fechaHoraEntrega.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " a las " +
					rto.comprobante.fechaHoraEntrega.format(DateTimeFormatter.ofPattern("HH:mm")) + " hs. a " +
					rto.comprobante.nombre_completo + " (DNI: " + rto.comprobante.dni + ").\n\n"
		}

		mje += "\nMuchas Gracias.\n"
		mje += usr.apellido + ", " + usr.nombre

		mje
	}
}
