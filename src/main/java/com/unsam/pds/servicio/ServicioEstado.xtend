package com.unsam.pds.servicio

import com.unsam.pds.dominio.entidades.Estado
import com.unsam.pds.repositorio.RepositorioEstado
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class ServicioEstado<T extends Estado> {
	
	@Autowired RepositorioEstado repo
	
	def void crearNuevoEstado(T nuevoEstado) {
		repo.save(nuevoEstado)		
	}
	
	private def <T extends Estado> T getEstadoByNombre(String estado) {
		repo.getByNombre(estado) as T	
	}
	
	def static <T extends Estado> T getByNombre(String estado) {
		var ServicioEstado<T> serv = new ServicioEstado<T>
		serv.getEstadoByNombre(estado) as T	
	}
}