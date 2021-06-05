package com.unsam.pds.web.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.http.MediaType
import org.springframework.http.HttpStatus
import java.util.List
import javax.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.unsam.pds.servicio.ServicioProducto
import com.unsam.pds.dominio.entidades.Producto
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Controller
@CrossOrigin("*")
@RequestMapping("/producto")
class ControllerProducto {

	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioProducto servicioProducto
	@JsonView(View.Producto.Lista)
	@GetMapping(path="/all/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Producto> obtenerProductosActivosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET - Obtener todos los productos activos del id usuario " + idUsuario)
		servicioProducto.obtenerProductosActivosPorUsuario(idUsuario)
	}
	
	@JsonView(View.Producto.Perfil)
	@GetMapping(path="/{idProducto}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Producto obtenerProducto(@PathVariable("idProducto") Long idProducto) {
		logger.info("GET - Obtener el producto con id producto " + idProducto)
		servicioProducto.obtenerProductoActivoPorId(idProducto)
	}

	// POST PRODUCTO
	@PostMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void crearProducto(@RequestBody Producto producto) {
		servicioProducto.guardarProducto(producto)
	}

	// PUT PRODUCTO
	@PutMapping(path="/{idProducto}", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarProducto(@PathVariable("idProducto") Long idProducto, 
		@RequestBody Producto producto
	) {
		servicioProducto.actualizarProducto(idProducto, producto)
	}

	// DELETE PRODUCTO
	@DeleteMapping(path="/{idProducto}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	def void eliminarProducto(@PathVariable("idProducto") Long idProducto) {
		servicioProducto.desactivarProduto(idProducto)
	}
}
