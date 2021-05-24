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
import com.unsam.pds.servicio.ServicioDireccion
import javax.transaction.Transactional

@Controller
@CrossOrigin("*")
@RequestMapping("/cliente")
class ControllerCliente {
	
	@Autowired ServicioCliente servicioClientes
	@Autowired ServicioDireccion servicioDirecciones
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Cliente> obtenerTodosLosClientesPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		servicioClientes.obtenerClientesPorUsuario(idUsuario)
	}
	
	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void crearCliente(@RequestBody Cliente nuevoCliente) {		
		servicioDirecciones.crearNuevaDireccion(nuevoCliente.direccion)
		servicioClientes.crearNuevoCliente(nuevoCliente)
	}
}