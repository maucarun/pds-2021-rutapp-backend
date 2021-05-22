package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Producto

interface RepositorioProducto extends CrudRepository <Producto, Long>{
	
}