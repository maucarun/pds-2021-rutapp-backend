package com.unsam.pds.servicio

import com.unsam.pds.dominio.entidades.Estado
import com.unsam.pds.repositorio.RepositorioTipoEstado
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import com.unsam.pds.dominio.Generics.GenericService

@Service
class ServicioEstado<T extends Estado> extends GenericService<T, Long> {
	
	@Autowired RepositorioTipoEstado<T> repoEstado
	
	def void crearNuevoEstado(T nuevoEstado) {
		repoEstado.save(nuevoEstado)		
	}
	
	 def <T extends Estado> T getEstadoByNombre(String estado) {
		repoEstado.getByNombre(estado) as T	
	}
	
	def T obtenerEstadoPorId(Long idEstado) {
		repoEstado.findById(idEstado).get
	}
}