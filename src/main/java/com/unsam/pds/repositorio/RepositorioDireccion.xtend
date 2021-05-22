package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Direccion

interface RepositorioDireccion extends CrudRepository <Direccion, Long> {
	
}