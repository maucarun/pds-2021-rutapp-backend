package com.unsam.pds.servicio

import com.unsam.pds.dominio.entidades.Estado
import com.unsam.pds.repositorio.RepositorioTipoEstado
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import com.unsam.pds.dominio.Generics.GenericService
import java.util.List

@Service
class ServicioEstado<T extends Estado> extends GenericService<T, Long> {
	
	@Autowired RepositorioTipoEstado<T> repoEstado
	
	def void crearNuevoEstado(T nuevoEstado) {
		repoEstado.save(nuevoEstado)		
	}
	
	 def T getEstadoByNombre(String tipo, String estado) {
		repoEstado.getByTipoAndNombre(tipo, estado)
	}
	
	def T obtenerEstadoPorId(Long idEstado) {
		repoEstado.findById(idEstado).get
	}
	
	def T obtenerEstadoPorTipoAndId(String tipo, Long idEstado) {
		repoEstado.getById(tipo, idEstado)
	}
	
	def List<T> obtenerEstados() {
		repoEstado.findAll() as List<T>
	}
	
	def List<T> obtenerEstadosPorTipo(String tipo) {
		repoEstado.getByTipo(tipo)
	}
}