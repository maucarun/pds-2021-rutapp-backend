package com.unsam.pds.servicio

import com.unsam.pds.dominio.entidades.Producto
import com.unsam.pds.repositorio.RepositorioProducto
import java.util.List
import javassist.NotFoundException
import javax.transaction.Transactional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@Service
class ServicioProducto {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired RepositorioProducto repositorioProductos
	
	
	def List<Producto> obtenerProductosActivosPorUsuario(Long idUsuario) {
		repositorioProductos.findByPropietario_IdUsuarioAndActivo(idUsuario, true)
	}
	
	def List<Producto> obtenerTodosLosProductos() {
		repositorioProductos.findAll.toList
	}
	
	
	def Producto obtenerProductoActivoPorId(Long idProducto){
		repositorioProductos.findByIdProductoAndActivo(idProducto, true).orElseThrow([
			throw new NotFoundException("No existe el Producto con el id: " + idProducto)
		])
	}

	@Transactional
	def void guardarProducto(Producto producto) {
		logger.info("Guardando el producto " + producto.nombre)
		repositorioProductos.save(producto)
		logger.info("Producto creado exitosamente!")
	}

	@Transactional
	def void actualizarProducto(Long idProducto, Producto producto) {
		logger.info("Actualizando el producto " + producto.nombre)
		obtenerProductoActivoPorId(idProducto)
		guardarProducto(producto)
	}
	
	@Transactional
	def void desactivarProduto(Long idProducto){
		var producto = obtenerProductoActivoPorId(idProducto)
		producto.desactivarProducto
		logger.info("Cliente desactivado exitosamente!")
	}
}