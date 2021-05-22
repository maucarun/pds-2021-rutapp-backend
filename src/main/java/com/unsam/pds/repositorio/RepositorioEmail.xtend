package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Email

interface RepositorioEmail extends CrudRepository <Email, Long> {
	
}