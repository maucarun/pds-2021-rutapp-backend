package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Estado
import org.springframework.data.jpa.repository.Query
import org.springframework.context.annotation.Primary

//CREO  ESTE PARA NO ROMPER EL BOOTSTRAP
@Primary
interface RepositorioTipoEstado<T extends Estado>  extends GenericRepository<T, Long>{
	def Estado getByNombre(String estado)
	
	@Query(value = "SELECT * FROM estado WHERE id_estado=?1", nativeQuery = true)
	override T getById(Long id)
}