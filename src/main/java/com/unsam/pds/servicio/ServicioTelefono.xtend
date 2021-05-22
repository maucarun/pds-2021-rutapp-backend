package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.RepositorioTelefono
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.dominio.entidades.Telefono

@Service
class ServicioTelefono {
	
	@Autowired RepositorioTelefono repositorioTelefonos
	
	def void crearNuevoTelefono(Telefono nuevoTelefono) {
		repositorioTelefonos.save(nuevoTelefono)
	}
	
}