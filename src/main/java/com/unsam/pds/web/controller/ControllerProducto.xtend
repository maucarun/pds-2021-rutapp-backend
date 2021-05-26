package com.unsam.pds.web.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.servicio.ServicioCliente
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.ResponseBody
import java.util.List
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus
import javax.transaction.Transactional
import org.springframework.web.bind.annotation.PutMapping
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.unsam.pds.servicio.ServicioProducto
import com.unsam.pds.dominio.entidades.Producto
import org.springframework.web.bind.annotation.DeleteMapping

@Controller
@CrossOrigin("*")
@RequestMapping("/producto")
class ControllerProducto {

	Logger logger = LoggerFactory.getLogger(ControllerCliente)

	@Autowired ServicioProducto servicioProducto

	// GET ALL PRODUCTOS
	@GetMapping(path="/all/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Producto> obtenerTodosLosProductosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		servicioProducto.obtenerTodosLosProductosPorUsuario(idUsuario)
	}

	// GET PRODUCTO
	@GetMapping(path="/{idProducto}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Producto obtenerProducto(@PathVariable("idProducto") Long idProducto) {
		servicioProducto.obtenerUnProdutoPorId(idProducto)
	}

	// POST PRODUCTO
	@PostMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void crearProducto(@RequestBody Producto producto) {
		servicioProducto.crearNuevoProducto(producto)
	}

	// PUT PRODUCTO
	@PutMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarProducto(@RequestBody Producto producto) {
		servicioProducto.actualizarProducto(producto)
	}

	// DELETE PRODUCTO
	@DeleteMapping(path="/{idProducto}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def void eliminarProducto(@PathVariable("idProducto") Long idProducto) {
		servicioProducto.eliminarUnProdutoPorId(idProducto)
	}
}
