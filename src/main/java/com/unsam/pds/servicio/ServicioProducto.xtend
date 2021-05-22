package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.RepositorioProducto
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.dominio.entidades.Producto

@Service
class ServicioProducto {
	
	@Autowired RepositorioProducto repositorioProductos
	
	def void crearNuevoProducto(Producto nuevoProducto) {
		repositorioProductos.save(nuevoProducto)
	}
}