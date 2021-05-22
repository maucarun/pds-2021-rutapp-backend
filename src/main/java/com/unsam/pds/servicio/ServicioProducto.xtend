package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.RepositorioProducto
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.dominio.entidades.Producto
import java.util.List

@Service
class ServicioProducto {
	
	@Autowired RepositorioProducto repositorioProductos

	@Autowired ServicioUsuario servicioUsuarios
	
	
	def void crearNuevoProducto(Producto nuevoProducto) {
		repositorioProductos.save(nuevoProducto)
	}
	
	def List<Producto> obtenerTodosLosProductosPorUsuario(Long idUsuario) {
		var usuario = servicioUsuarios.obtenerUsuarioPorId(idUsuario)
		repositorioProductos.findByPropietario(usuario)
	}
	
	def List<Producto> obtenerTodosLosProductos() {
		repositorioProductos.findAll.toList
	}
}