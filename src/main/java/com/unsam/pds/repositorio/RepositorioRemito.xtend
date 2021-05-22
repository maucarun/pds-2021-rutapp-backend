package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Remito

interface RepositorioRemito extends CrudRepository <Remito, Long> {
	
}