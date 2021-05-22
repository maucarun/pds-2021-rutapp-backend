package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Producto
import java.util.List
import com.unsam.pds.dominio.entidades.Usuario

interface RepositorioProducto extends CrudRepository <Producto, Long>{
	
	def List<Producto> findByPropietario(Usuario propietario)
	
}