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
import com.unsam.pds.dominio.Generics.GenericService

@Service
class ServicioProducto extends GenericService<Producto, Long> {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired RepositorioProducto repo
	
	
	def List<Producto> obtenerProductosActivosPorUsuario(Long idUsuario) {
		repo.findByPropietario_IdUsuarioAndActivo(idUsuario, true)
	}
	
	def List<Producto> obtenerTodosLosProductos() {
		repo.findAll.toList
	}
	
	
	def Producto obtenerProductoActivoPorId(Long idProducto){
		repo.findByIdProductoAndActivo(idProducto, true).orElseThrow([
			throw new NotFoundException("No existe el Producto con el id: " + idProducto)
		])
	}

	@Transactional
	def void guardarProducto(Producto producto) {
		logger.info("Guardando el producto " + producto.nombre)
		repo.save(producto)
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