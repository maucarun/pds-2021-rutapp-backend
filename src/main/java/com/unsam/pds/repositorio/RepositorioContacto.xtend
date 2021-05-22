package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Contacto

interface RepositorioContacto extends CrudRepository <Contacto, Long> {
	
}