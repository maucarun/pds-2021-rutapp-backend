package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioEmail
import com.unsam.pds.dominio.entidades.Email
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.Contacto

@Service
class ServicioEmail {
	
	@Autowired RepositorioEmail repositorioEmails
	
	@Transactional
	def void crearNuevoEmail(Email nuevoEmail) {
		repositorioEmails.save(nuevoEmail)
	}

	@Transactional
	def void crearNuevosEmails(Contacto contacto) {
		contacto.emails.forEach[ email | email.contacto = contacto ]
		repositorioEmails.saveAll(contacto.emails)		
	}
}