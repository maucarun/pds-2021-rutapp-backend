package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.RepositorioEstado
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.dominio.entidades.Estado

@Service
class ServicioEstado {
	
	@Autowired RepositorioEstado repositorioEstados
	
	def void crearNuevoEstado(Estado nuevoEstado) {
		repositorioEstados.save(nuevoEstado)		
	}
}