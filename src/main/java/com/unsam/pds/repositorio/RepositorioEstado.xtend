package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Estado
import org.springframework.data.jpa.repository.Query

interface RepositorioEstado extends GenericRepository<Estado, Long> {
	def Estado getByNombre(String estado)
	
	@Query(value = "SELECT * FROM Estado WHERE id_estado=?1", nativeQuery = true)
	override Estado getById(Long id)
}
