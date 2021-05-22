package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Usuario

interface RepositorioUsuario extends CrudRepository <Usuario, Long> {
	
}