package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Producto
import java.util.List
import java.util.Optional

interface RepositorioProducto  extends GenericRepository<Producto, Long> {
	def List<Producto> findByPropietario_IdUsuarioAndActivo(Long idPropietario, Boolean estado)
	
	def Optional<Producto> findByIdProductoAndActivo(Long idProducto, Boolean estado)
	
	
	override Producto getById(Long id){
		findByIdProducto(id)
	}
	
	def Producto findByIdProducto(Long id)
}