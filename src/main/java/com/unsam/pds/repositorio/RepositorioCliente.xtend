package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Cliente

interface RepositorioCliente extends CrudRepository <Cliente, Long> {
	
}