package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Estado
import org.springframework.data.jpa.repository.Query
import org.springframework.context.annotation.Primary
import java.util.List

//CREO  ESTE PARA NO ROMPER EL BOOTSTRAP
@Primary
interface RepositorioTipoEstado<T extends Estado>  extends GenericRepository<T, Long>{
	@Query(value = "SELECT * FROM estado WHERE dtype=?1 AND nombre=?2", nativeQuery = true)
	def T getByTipoAndNombre(String tipo, String estado)
	
	@Query(value = "SELECT * FROM estado WHERE id_estado=?1", nativeQuery = true)
	override T getById(Long id)
	
	@Query(value = "SELECT * FROM estado WHERE dtype=?1", nativeQuery = true)
	def List<T> getByTipo(String tipo)
	
	@Query(value = "SELECT * FROM estado WHERE dtype=?1 AND id_estado=?2", nativeQuery = true)
	def T getById(String tipo, Long id)
}