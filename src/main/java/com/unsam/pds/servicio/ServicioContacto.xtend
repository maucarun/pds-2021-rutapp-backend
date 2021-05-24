package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioContacto
import com.unsam.pds.dominio.entidades.Contacto
import javax.transaction.Transactional
import java.util.Set

@Service
class ServicioContacto {
	
	@Autowired RepositorioContacto repositorioContactos
	
	@Transactional
	def void crearNuevoContacto (Contacto nuevoContacto) {
		repositorioContactos.save(nuevoContacto)
	}
	
	@Transactional
	def void crearNuevosContactos(Set<Contacto> contactos) {
		repositorioContactos.saveAll(contactos)		
	}
	
}