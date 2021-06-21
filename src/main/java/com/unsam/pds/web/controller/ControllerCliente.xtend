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
import com.unsam.pds.dominio.Generics.PaginationResponse
import net.kaczmarzyk.spring.data.jpa.web.annotation.Spec
import net.kaczmarzyk.spring.data.jpa.web.annotation.And
import net.kaczmarzyk.spring.data.jpa.domain.Equal
import net.kaczmarzyk.spring.data.jpa.domain.Like
import org.springframework.data.jpa.domain.Specification
import org.springframework.data.domain.Sort
import org.springframework.http.HttpHeaders
import org.springframework.web.bind.annotation.RequestHeader
import com.unsam.pds.dominio.Generics.GenericController
import net.kaczmarzyk.spring.data.jpa.domain.Between
import com.unsam.pds.dominio.entidades.Usuario
import com.unsam.pds.dominio.Exceptions.NotFoundException
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.dominio.entidades.Disponibilidad
import java.util.Set
import com.unsam.pds.servicio.ServicioDiaSemana

@Controller
@CrossOrigin("*")
@RequestMapping("/cliente")
class ControllerCliente extends GenericController<Cliente> {

	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioCliente servicioClientes
	@Autowired ServicioDiaSemana servicioDiaSemana
	
	@GetMapping(path="/disponibilidades", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Set<Disponibilidad> obtenerDisponibilidadesVacias() {
		var List<Disponibilidad> nuevasDisponibilidades = newArrayList
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Lunes")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Martes")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Miercoles")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Jueves")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Viernes")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Sabado")))
		nuevasDisponibilidades.add(new Disponibilidad(servicioDiaSemana.obtenerDiaPorNombre("Domingo")))
		return nuevasDisponibilidades.toSet
	}
	
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
	def Cliente obtenerClienteActivoDelUsuarioPorUsuarioIdYClienteId(@PathVariable("idUsuario") Long idUsuario,
		@PathVariable("idCliente") Long idCliente) {
		logger.info("GET obtener el cliente con id " + idCliente + " del usuario con el id " + idUsuario)
		servicioClientes.obtenerClienteActivoDelUsuarioPorId(idCliente, idUsuario)
	}

	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void crearCliente(@RequestBody Cliente nuevoCliente,
		@RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		
		nuevoCliente.propietario = new Usuario()
		nuevoCliente.propietario.idUsuario = usr
		
		logger.info("POST agregar nuevo cliente")
		servicioClientes.crearNuevoCliente(nuevoCliente)
	}
	
	@PutMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarCLiente(
		@RequestBody Cliente clienteModificado,	
		@RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)

		var Cliente clie = servicioClientes.getById(clienteModificado.idCliente)

		if (clie === null || !clie.activo)
			throw new NotFoundException

		if (clie.propietario === null || clie.propietario.idUsuario !== usr)
			throw new UnauthorizedException
		
		logger.info("PUT actualizar el cliente con id " + clienteModificado.idCliente + " del usuario con el id " + usr)
		servicioClientes.actualizarCliente(clienteModificado, clienteModificado.idCliente, usr)
	}

	@DeleteMapping(path="/usuario/{idUsuario}/cliente/{idCliente}")
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void desactivarCliente(
		@PathVariable("idUsuario") Long idUsuario,
		@PathVariable("idCliente") Long idCliente
	) {
		logger.info("DELETE desactivar el cliente con id " + idCliente)
		servicioClientes.desactivarCliente(idCliente, idUsuario)
	}

	@GetMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(HttpStatus.OK)
	@JsonView(View.Cliente.Lista)
	@ResponseBody
	def PaginationResponse<Cliente> getAll(@And(#[
		@Spec(path="idCliente", params="id", spec=typeof(Equal)),
		@Spec(path="nombre", params="nombre", spec=typeof(Like)),
		@Spec(path="cuit", params="cuit", spec=typeof(Equal)),
		@Spec(path="activo", params="activo", spec=typeof(Equal)),
		@Spec(path="promedio_espera", params=#["esperadesde", "esperahasta"], spec=typeof(Between))
	])
	Specification<Cliente> spec, Sort sort, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = AgregarFiltro(spec, "propietario", usr)

		servicioClientes.getByFilter(specUsr, headers, sort)
	}

	@GetMapping(value="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(View.Cliente.Perfil)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	def Cliente get(@PathVariable("id") Long idClie, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = AgregarFiltro(null, "propietario", usr)

		specUsr = AgregarFiltro(specUsr, "idCliente", idClie)

		servicioClientes.get(specUsr)
	}

//	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseStatus(code=HttpStatus.CREATED)
//	@JsonView(View.Cliente.Perfil)
//	@ResponseBody
//	@Transactional
//	def Cliente set(@RequestBody @JsonView(View.Cliente.Post) Cliente nuevoCliente,
//		@RequestHeader HttpHeaders headers) {
//		var Long usr = getUsuarioIdFromLogin(headers)
//
//		nuevoCliente.propietario = new Usuario()
//		nuevoCliente.propietario.idUsuario = usr
//
//		servicioClientes.save(nuevoCliente)
//	}

//	@PutMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseStatus(code=HttpStatus.OK)
//	@JsonView(View.Cliente.Perfil)
//	@ResponseBody
//	@Transactional
//	def Cliente actualizarCLiente(@RequestBody @JsonView(View.Cliente.Put) Cliente cliente,
//		@RequestHeader HttpHeaders headers) {
//		var Long usr = getUsuarioIdFromLogin(headers)
//
//		var Cliente clie = servicioClientes.getById(cliente.idCliente)
//
//		if (clie === null || !clie.activo)
//			throw new NotFoundException
//
//		if (clie.propietario === null || clie.propietario.idUsuario !== usr)
//			throw new UnauthorizedException
//		
//		cliente.propietario = cliente.propietario === null ? clie.propietario : cliente.propietario
//		cliente.cuit = cliente.cuit === null ? clie.cuit : cliente.cuit
//		cliente.nombre = cliente.nombre === null ? clie.nombre : cliente.nombre
//		cliente.observaciones = cliente.observaciones === null ? clie.observaciones : cliente.observaciones
//		cliente.direccion = cliente.direccion === null ? clie.direccion : cliente.direccion
//		cliente.promedio_espera = cliente.promedio_espera === null ? clie.promedio_espera : cliente.promedio_espera
//		cliente.activo = cliente.activo === null ? clie.activo : cliente.activo
//
//		servicioClientes.save(cliente)
//	}

	@DeleteMapping(path="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@ResponseBody
	def com.unsam.pds.dominio.Generics.ResponseBody delete(@PathVariable("id") Long id, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var Cliente clie = servicioClientes.getById(id)
		
		if (clie === null || !clie.activo)
			throw new NotFoundException

		if (clie.propietario === null || clie.propietario.idUsuario !== usr)
			throw new UnauthorizedException

		clie.activo  = false

		servicioClientes.save(clie)
		
		new com.unsam.pds.dominio.Generics.ResponseBody() => [
			code = HttpStatus.OK.toString
			message = "Cliente eliminado exitosamente"
		]
	}

}
