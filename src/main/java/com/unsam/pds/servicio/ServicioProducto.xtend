package com.unsam.pds.servicio

import com.unsam.pds.dominio.entidades.Producto
import com.unsam.pds.repositorio.RepositorioProducto
import java.util.List
import javassist.NotFoundException
import javax.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class ServicioProducto {
	
	@Autowired RepositorioProducto repositorioProductos
	@Autowired ServicioUsuario servicioUsuarios
	
	@Transactional
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
	
	@Transactional
	def void actualizarProducto(Producto producto) {
		repositorioProductos.save(producto)
	}
	
	def Producto obtenerUnProdutoPorId(Long idProducto){
		//TODO no estoy usando el idUsuario
		repositorioProductos.findById(idProducto).orElseThrow([
			throw new NotFoundException("No existe el Producto con el id: " + idProducto)
		])
	}
	
	@Transactional
	def void eliminarUnProdutoPorId(Long idProducto){
		repositorioProductos.deleteById(idProducto)
	}
}