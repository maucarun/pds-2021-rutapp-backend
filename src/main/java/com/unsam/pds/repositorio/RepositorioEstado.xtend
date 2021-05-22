package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Estado

interface RepositorioEstado extends CrudRepository <Estado, Long> {
	
}