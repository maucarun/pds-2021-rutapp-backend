package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioContacto
import com.unsam.pds.dominio.entidades.Contacto
import javax.transaction.Transactional
import java.util.Set
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.BeanUtils
import javassist.NotFoundException
import com.unsam.pds.dominio.entidades.Cliente

@Service
class ServicioContacto {
	
	Logger logger = LoggerFactory.getLogger(ServicioContacto)
	
	@Autowired RepositorioContacto repositorioContactos
	
	@Autowired ServicioEmail servicioEmails
	@Autowired ServicioTelefono servicioTelefonos
	
	def Contacto obtenerContactoPorId(Long idContacto) {
		repositorioContactos.findById(idContacto).orElseThrow([
			throw new NotFoundException("No existe el contacto con el id " + idContacto)
		])
	}
	
	@Transactional
	def void crearNuevoContacto (Contacto nuevoContacto) {
		logger.info("Creando el contacto " + nuevoContacto.nombre.concat(" " + nuevoContacto.apellido))
		repositorioContactos.save(nuevoContacto)
		logger.info("Contacto creado exitosamente!")
	}
	
	@Transactional
	def void crearNuevosContactos(Cliente cliente) {
		logger.info("Creando " + cliente.contactos.size + "contactos")
		//cliente.contactos.forEach[ contacto | contacto.cliente = cliente ]
		//println(cliente.contactos)
		repositorioContactos.saveAll(cliente.contactos)
		
//		cliente.contactos.forEach[contacto | 
//			logger.info("Guardando los " + contacto.emails.size + " emails del contacto " + contacto.nombre)
//			servicioEmails.crearNuevosEmails(contacto)
//
//			logger.info("Guardando los " + contacto.telefonos.size + " telefonos del contacto " + contacto.nombre)
//			servicioTelefonos.crearNuevosTelefonos(contacto)
//		]
		
		logger.info("Contactos creados exitosamente!")
	}
	
	@Transactional
	def void actualizarContactos(Set<Contacto> contactosAModificar) {
		contactosAModificar.forEach[contactoModificado |
			var contactoAModificar = obtenerContactoPorId(contactoModificado.id_contacto)
			BeanUtils.copyProperties(contactoModificado, contactoAModificar)
			crearNuevoContacto(contactoAModificar)			
			logger.info("Actualizando los " + contactoModificado.emails + " emails del contacto " + contactoModificado.nombre)
			servicioEmails.crearNuevosEmails(contactoModificado)

			logger.info("Actualizando los " + contactoModificado.telefonos + " telefonos del contacto " + contactoModificado.nombre)
			servicioTelefonos.crearNuevosTelefonos(contactoModificado)
		]
		logger.info("Contactos actualizados exitosamente!")
		
	}
	
	
}