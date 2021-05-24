package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioContacto
import com.unsam.pds.dominio.entidades.Contacto
import javax.transaction.Transactional
import java.util.Set
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@Service
class ServicioContacto {
	
	Logger logger = LoggerFactory.getLogger(ServicioRemito)
	
	@Autowired RepositorioContacto repositorioContactos
	
	@Autowired ServicioEmail servicioEmails
	@Autowired ServicioTelefono servicioTelefonos
	
	@Transactional
	def void crearNuevoContacto (Contacto nuevoContacto) {
		logger.info("Creando el contacto " + nuevoContacto.nombre.concat(" " + nuevoContacto.apellido))
		repositorioContactos.save(nuevoContacto)
		logger.info("Contacto creado exitosamente!")
	}
	
	@Transactional
	def void crearNuevosContactos(Set<Contacto> contactos) {
		logger.info("Creando " + contactos.size + "vcontactos")
		repositorioContactos.saveAll(contactos)
		
		contactos.forEach[contacto | 
			logger.info("Guardando los " + contacto.emails + " emails del contacto " + contacto.nombre)
			contacto.emails.forEach[ email | email.contacto = contacto ]

			logger.info("Guardando los " + contacto.telefonos + " telefonos del contacto " + contacto.nombre)
			contacto.telefonos.forEach[ telefono | telefono.contacto = contacto ]
			
			servicioEmails.crearNuevosEmails(contacto.emails)
			servicioTelefonos.crearNuevosTelefonos(contacto.telefonos)
		]
		logger.info("Contactos creados exitosamente!")
	}
	
}