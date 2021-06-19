package com.unsam.pds.web.controller

import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.dominio.Exceptions.NotFoundException
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.dominio.Generics.GenericController
import com.unsam.pds.dominio.Generics.PaginationResponse
import com.unsam.pds.dominio.entidades.Cliente
import com.unsam.pds.dominio.entidades.Remito
import com.unsam.pds.dominio.entidades.Usuario
import com.unsam.pds.servicio.ServicioEstado
import com.unsam.pds.servicio.ServicioRemito
import com.unsam.pds.web.view.View
import java.util.List
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Join
import javax.persistence.criteria.Root
import javax.transaction.Transactional
import net.kaczmarzyk.spring.data.jpa.domain.Between
import net.kaczmarzyk.spring.data.jpa.domain.Equal
import net.kaczmarzyk.spring.data.jpa.domain.Like
import net.kaczmarzyk.spring.data.jpa.web.annotation.And
import net.kaczmarzyk.spring.data.jpa.web.annotation.Spec
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.domain.Specification
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.client.HttpClientErrorException
import com.unsam.pds.dominio.entidades.EstadoRemito

@Controller
@CrossOrigin("*")
@RequestMapping("/remito")
class ControllerRemito extends GenericController<Remito> {
	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioRemito servicioRemito
	@Autowired ServicioEstado servicioEstado
	

	// GET ALL REMITOS por id usuario
	@JsonView(View.Remito.Lista)
	@GetMapping(path="/all/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerTodosLosRemitosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET localhost:8080/remito/all/" + idUsuario)
		servicioRemito.obtenerRemitosPorIdUsuario(idUsuario)
	}
	
	// GET REMITOS por id cliente y estado pendiente
	@JsonView(View.Remito.Lista)
	@GetMapping(path="/all", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerRemito(@RequestParam("idCliente") Long idCliente, @RequestParam("estado") String estado) {
		logger.info("GET localhost:8080/remito/all?" + idCliente + "&estado=" + estado)
		servicioRemito.obtenerRemitosPendientesPorIdCliente(idCliente)
	}

//	// GET REMITO por id remito
//	@JsonView(View.Remito.Perfil)
//	@GetMapping(path="/{idRemito}", produces=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	def Remito obtenerRemito(@PathVariable("idRemito") Long idRemito) {
//		logger.info("GET localhost:8080/" + idRemito)
//		servicioRemito.obtenerRemitoPorId(idRemito)
//	}

//	// POST REMITO
//	@PostMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseStatus(code=HttpStatus.OK)
//	@Transactional
//	def void crearRemito(@RequestBody Remito remito) {
//		logger.info("POST localhost:8080/" + remito)
//		servicioRemito.actualizarOCrearRemito(remito)
//	}
//	// PUT REMITO
//	@PutMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseStatus(code=HttpStatus.OK)
//	@Transactional
//	def void actualizarRemito(@RequestBody Remito remito) {
//		logger.info("PUT localhost:8080/" + remito)
//		servicioRemito.actualizarOCrearRemito(remito)
//	}
///////////////////////////////////////////////////////////////////////////////////////////
	@GetMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(HttpStatus.OK)
	@JsonView(View.Remito.Lista)
	@ResponseBody
	def PaginationResponse<Remito> getAll(@And(#[
		@Spec(path="id_remito", params="id", spec=typeof(Equal)),
		@Spec(path="motivo", params="motivo", spec=typeof(Like)),
		@Spec(path="cliente", params="cliente", spec=typeof(Like)),
		@Spec(path="hojaDeRuta", params="hojaDeRuta", spec=typeof(Equal)),
		@Spec(path="fecha", params=#["fechaDesde", "fechaHasta"], spec=typeof(Between)),
		@Spec(path="tiempo_espera", params=#["esperadesde", "esperahasta"], spec=typeof(Between))
	])
	Specification<Remito> spec, Sort sort, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = joinClienteUsuario(spec, usr)

		servicioRemito.getByFilter(specUsr, headers, sort)
	}

	@GetMapping(value="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(View.Remito.Perfil)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	def Remito get(@PathVariable("id") Long id, @RequestHeader HttpHeaders headers) {
		//var Long usr = getUsuarioIdFromLogin(headers)

		//var spec = joinClienteUsuario(null, usr)
		//spec = AgregarFiltro(spec, "id_remito", id)
		
		servicioRemito.getById(id)
	}

	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void set(@RequestBody Remito remito, @RequestHeader HttpHeaders headers) {
		logger.info("Intentando guardar remito");
		var Long usr = getUsuarioIdFromLogin(headers)
		
		if(remito.cliente === null || remito.cliente.idCliente === null)
			throw new HttpClientErrorException(HttpStatus.BAD_REQUEST, "Cliente inexistente")
			
		var cliente = servicioRemito.getClienteById(remito.cliente.idCliente)

		if (cliente.propietario === null || cliente.propietario.idUsuario != usr)
			throw new UnauthorizedException
			
		remito.cliente = cliente
//		remito.estado = servicioEstado.obtenerEstadoPorNombre("Pendiente", "estado_remito")
		remito.estado = servicioEstado.obtenerEstadoPorId(6L) as EstadoRemito
		remito.productosDelRemito.forEach[pr | pr.descuento = 1.0]
		
		logger.info("Guardaré el remito del cliente " + remito.cliente.nombre);
		servicioRemito.actualizarOCrearRemito(remito)
	}

	@PutMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@JsonView(View.Remito.Perfil)
	@ResponseBody
	@Transactional
	def Remito update(@RequestBody @JsonView(View.Producto.Put) Remito remito, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)

		var Remito rmt = servicioRemito.getById(remito.id_remito)

		if (rmt === null || rmt.estado.nombre !== "Pendiente")
			throw new NotFoundException

		if (rmt.cliente.propietario === null || rmt.cliente.propietario.idUsuario !== usr)
			throw new UnauthorizedException

		remito.cliente = remito.cliente === null ? rmt.cliente : remito.cliente
		remito.estado = remito.estado === null ? rmt.estado : remito.estado
		remito.hojaDeRuta = remito.hojaDeRuta === null ? rmt.hojaDeRuta : remito.hojaDeRuta
		remito.fechaDeCreacion = remito.fechaDeCreacion === null ? rmt.fechaDeCreacion : remito.fechaDeCreacion
		remito.total = remito.estado === null ? rmt.total : remito.total
		remito.motivo = remito.motivo === null ? rmt.motivo : remito.motivo
		remito.tiempo_espera = remito.tiempo_espera === null ? rmt.tiempo_espera : remito.tiempo_espera
		remito.comprobante = remito.comprobante === null ? rmt.comprobante : remito.comprobante

		servicioRemito.save(remito)
	}

	@DeleteMapping(path="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@ResponseBody
	def com.unsam.pds.dominio.Generics.ResponseBody delete(@PathVariable("id") Long id,
		@RequestHeader HttpHeaders headers) {
		logger.info("Intentando cancelar el remito id " + id)
		
		var Long usuarioId = getUsuarioIdFromLogin(headers)
		var Remito rmt = servicioRemito.getById(id)
		
		logger.info("El usuario id " + usuarioId + " quiere cancelar el remito id " + id + " con estado " + rmt.estado.nombre)

		if (rmt === null || rmt.estado.nombre != "Pendiente")
			throw new NotFoundException

		if (rmt.cliente.propietario === null || rmt.cliente.propietario.idUsuario !== usuarioId)
			throw new UnauthorizedException
	
		rmt.estado = servicioEstado.obtenerEstadoPorId(5L) as EstadoRemito

		servicioRemito.save(rmt)

		new com.unsam.pds.dominio.Generics.ResponseBody() => [
			code = HttpStatus.OK.toString
			message = "Remito eliminado exitosamente"
		]
	}

	private def Specification<Remito> joinClienteUsuario(Specification<Remito> spec, Long idUsuario) {
		var pr = new Specification<Remito>() {

			override toPredicate(Root<Remito> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				var Join<Cliente, Remito> rto = root.join("cliente")
				var Join<Usuario, Cliente> clie = rto.join("propietario")
				cb.equal(clie.get("idUsuario"), idUsuario)
			}
		}
		spec === null ? pr : pr.and(spec)
	}
}
