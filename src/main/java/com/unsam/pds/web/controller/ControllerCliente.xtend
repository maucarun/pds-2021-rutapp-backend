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
import com.unsam.pds.servicio.ServicioDisponibilidad
import com.unsam.pds.servicio.ServicioEmail
import com.unsam.pds.servicio.ServicioTelefono
import com.unsam.pds.servicio.ServicioContacto
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus
import com.unsam.pds.servicio.ServicioDireccion

@Controller
@CrossOrigin("*")
@RequestMapping("/cliente")
class ControllerCliente {
	
	@Autowired ServicioCliente servicioClientes
	@Autowired ServicioContacto servicioContactos
	@Autowired ServicioDireccion servicioDirecciones
	@Autowired ServicioDisponibilidad servicioDisponibilidad
	@Autowired ServicioEmail servicioEmails
	@Autowired ServicioTelefono servicioTelefonos
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Cliente> obtenerTodosLosClientesPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		servicioClientes.obtenerClientesPorUsuario(idUsuario)
	}
	
	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@ResponseStatus(code=HttpStatus.CREATED)
	def void crearCliente(@RequestBody Cliente nuevoCliente) {		
		servicioDirecciones.crearNuevaDireccion(nuevoCliente.direccion)
		servicioClientes.crearNuevoCliente(nuevoCliente)

//		servicioContactos.crearNuevosContactos(nuevoCliente.contactos)
		nuevoCliente.contactos.forEach[contacto | 
			servicioContactos.crearNuevoContacto(contacto)
			servicioEmails.crearNuevosEmails(contacto.emails)
			servicioTelefonos.crearNuevosTelefonos(contacto.telefonos)
		]
		
		servicioDisponibilidad.crearNuevaDisponibilidades(nuevoCliente.disponibilidades)
		
		
	}
}