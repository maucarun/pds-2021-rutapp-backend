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

@Controller
@CrossOrigin("*")
@RequestMapping("/cliente")
class ControllerCliente {
	
	Logger logger = LoggerFactory.getLogger(ControllerCliente)
	
	@Autowired ServicioCliente servicioClientes
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Cliente> obtenerTodosLosClientesPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos los clientes del usuario con el id " + idUsuario)
		servicioClientes.obtenerClientesPorUsuario(idUsuario)
	}
	
	@GetMapping(path="/usuario/{idUsuario}/cliente/{idCliente}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Cliente obtenerClienteDelUsuarioPorId(@PathVariable("idUsuario") Long idUsuario, @PathVariable("idCliente") Long idCliente) {
		logger.info("GET obtener el cliente con id " + idCliente + 
			" del usuario con el id " + idUsuario)
		servicioClientes.obtenerClienteDelUsuarioPorId(idCliente, idUsuario)
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
	
}