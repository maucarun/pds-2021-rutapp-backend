package com.unsam.pds.web.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.stereotype.Controller
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.servicio.ServicioCliente
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.ResponseBody
import java.util.List
import com.unsam.pds.dominio.entidades.Cliente
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus
import javax.transaction.Transactional
import org.springframework.web.bind.annotation.PutMapping
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.DeleteMapping
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Controller
@CrossOrigin("*")
@RequestMapping("/cliente")
class ControllerCliente {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired ServicioCliente servicioClientes
	
	@JsonView(View.Cliente.Lista)
	@GetMapping(path="/activo/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Cliente> obtenerClientesActivosPorUsuarioId(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos los clientes activos del usuario id " + idUsuario)
		servicioClientes.obtenerClientesActivosPorUsuario(idUsuario)
	}
	
	@JsonView(View.Cliente.Lista)
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Cliente> obtenerClientesPorUsuarioId(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos los clientes del usuario id " + idUsuario)
		servicioClientes.obtenerClientesPorIdUsuario(idUsuario)
	}
	
	@JsonView(View.Cliente.Perfil)
	@GetMapping(path="/usuario/{idUsuario}/cliente/{idCliente}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Cliente obtenerClienteActivoDelUsuarioPorUsuarioIdYClienteId(@PathVariable("idUsuario") Long idUsuario, @PathVariable("idCliente") Long idCliente) {
		logger.info("GET obtener el cliente con id " + idCliente + 
			" del usuario con el id " + idUsuario)
		servicioClientes.obtenerClienteActivoDelUsuarioPorId(idCliente, idUsuario)
	}
	
	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void crearCliente(@RequestBody Cliente nuevoCliente) {
		logger.info("POST agregar nuevo cliente")
		servicioClientes.crearNuevoCliente(nuevoCliente)
	}
	
	@PutMapping(path="/usuario/{idUsuario}/cliente/{idCliente}", consumes=MediaType.APPLICATION_JSON_VALUE) 
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarCLiente(@PathVariable("idUsuario") Long idUsuario, 
		@PathVariable("idCliente") Long idCliente, 
		@RequestBody Cliente clienteModificado
	) {
		logger.info("PUT actualizar el cliente con id " + idCliente + 
			" del usuario con el id " + idUsuario)
		servicioClientes.actualizarCliente(clienteModificado, idCliente, idUsuario)
	}
	
	@DeleteMapping(path="/usuario/{idUsuario}/cliente/{idCliente}")
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void desactivarCliente(
		  @PathVariable("idUsuario") Long idUsuario
		, @PathVariable("idCliente") Long idCliente
	) {
		logger.info("DELETE desactivar el cliente con id " + idCliente)
		servicioClientes.desactivarCliente(idCliente, idUsuario)
	}
	
}