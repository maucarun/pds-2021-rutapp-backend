package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioEmail
import com.unsam.pds.dominio.entidades.Email

@Service
class ServicioEmail {
	
	@Autowired RepositorioEmail repositorioEmails
	
	def void crearNuevoEmail(Email nuevoEmail) {
		repositorioEmails.save(nuevoEmail)
	}
}