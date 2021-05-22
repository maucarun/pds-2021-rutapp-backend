package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Telefono

interface RepositorioTelefono extends CrudRepository <Telefono, Long> {
	
}