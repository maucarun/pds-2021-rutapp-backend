package com.unsam.pds.repositorio

import com.unsam.pds.dominio.entidades.Estado
import org.springframework.data.repository.CrudRepository

interface RepositorioEstado extends CrudRepository<Estado, Long> {
	def Estado getByNombre(String estado)
}