package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioContacto
import com.unsam.pds.dominio.entidades.Contacto

@Service
class ServicioContacto {
	
	@Autowired RepositorioContacto repositorioContactos
	
	def void crearNuevoContacto (Contacto nuevoContacto) {
		repositorioContactos.save(nuevoContacto)
	}
}