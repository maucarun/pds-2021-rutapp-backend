package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Producto
import java.util.List
import java.util.Optional

interface RepositorioProducto extends CrudRepository <Producto, Long>{
	
	def List<Producto> findByPropietario_IdUsuarioAndActivo(Long idPropietario, Boolean estado)
	
	def Optional<Producto> findByIdProductoAndActivo(Long idProducto, Boolean estado)
	
	
}