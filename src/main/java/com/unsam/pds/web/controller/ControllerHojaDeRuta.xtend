package com.unsam.pds.web.controller

import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.dominio.Exceptions.NotFoundException
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.dominio.Generics.GenericController
import com.unsam.pds.dominio.Generics.PaginationResponse
import com.unsam.pds.dominio.entidades.Cliente
import com.unsam.pds.dominio.entidades.HojaDeRuta
import com.unsam.pds.dominio.entidades.Remito
import com.unsam.pds.dominio.entidades.Usuario
import com.unsam.pds.servicio.ServicioHojaDeRuta
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
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.ResponseStatus
import com.unsam.pds.dominio.entidades.EstadoHojaDeRuta

@Controller
@CrossOrigin("*")
@RequestMapping("/hojaDeRuta")
class ControllerHojaDeRuta extends GenericController<HojaDeRuta> {

	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioHojaDeRuta servicioHojasDeRutas
	@Autowired ServicioRemito servRemito

	@JsonView(View.HojaDeRuta.Lista)
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<HojaDeRuta> obtenerHojasDeRutaPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos las hojas de ruta del usuario con el id " + idUsuario)
		servicioHojasDeRutas.obtenerHojasDeRutaPorIdUsuario(idUsuario)
	}

	@PutMapping(path="{idHdr}", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarHdr(
		@PathVariable("idHdr") Long idHdr,
		@RequestBody HojaDeRuta hdrModificada
	) {
		logger.info("PUT actualizar la hoja de ruta id " + idHdr)
		servicioHojasDeRutas.actualizarHdr(idHdr, hdrModificada)
	}

//////////////////////////////////////////////////////////////////////////////////////////77
	@GetMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(View.HojaDeRuta.Lista)
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	def PaginationResponse<HojaDeRuta> getAll(@And(#[
		@Spec(path="id_hoja_de_ruta", params="id", spec=Equal),
		@Spec(path="justificacion", params="causa", spec=Like),
		@Spec(path="estado.id_estado", params="estado", spec=Equal),
		@Spec(path="kms_recorridos", params=#["mksdesde", "mkshasta"], spec=Between),
		@Spec(path="fecha_hora_inicio", params=#["horainiciodesde", "horainiciohasta"], spec=Between),
		@Spec(path="fecha_hora_fin", params=#["horafindesde", "horafinhasta"], spec=Between)
	])
	Specification<HojaDeRuta> spec, Sort sort, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = joinHojaDeRutaUsuario(spec, usr)

		servicioHojasDeRutas.getByFilter(specUsr, headers, sort)
	}

	@GetMapping(value="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(View.HojaDeRuta.Perfil)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	def HojaDeRuta get(@PathVariable("id") Long id, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = joinHojaDeRutaUsuario(null, usr)

		specUsr = AgregarFiltro(specUsr, "id_hoja_de_ruta", id)

		servicioHojasDeRutas.get(specUsr)
	}

	@GetMapping(value="/Estados", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	def List<EstadoHojaDeRuta> getEstados(@RequestHeader HttpHeaders headers) {
		getUsuarioIdFromLogin(headers)

		servicioHojasDeRutas.allEstados
	}

	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@JsonView(View.HojaDeRuta.Perfil)
	@ResponseBody
	@Transactional
	def HojaDeRuta set(@RequestBody @JsonView(View.HojaDeRuta.Post) HojaDeRuta hoja,
		@RequestHeader HttpHeaders headers) {
		val Long usr = getUsuarioIdFromLogin(headers)

		if (hoja.remitos === null || hoja.remitos.length < 1)
			throw new NotFoundException("La hoja de ruta debe tener al menos un remito")
		if (hoja.remitos.filter[rto|val r = servRemito.getById(rto.idRemito); r.cliente.propietario.idUsuario !== usr].
			length > 0)
			throw new UnauthorizedException("Los remitos de la hoja de ruta deben pertenecer al usuario")

		hoja.estado = servicioHojasDeRutas.getEstadoById(hoja.estado.id_estado)

		servicioHojasDeRutas.crearNuevaHdr(hoja)
	}

	@PutMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@JsonView(View.HojaDeRuta.Lista)
	@ResponseBody
	@Transactional
	def HojaDeRuta update(@RequestBody @JsonView(View.HojaDeRuta.Put) HojaDeRuta hoja,
		@RequestHeader HttpHeaders headers) {
		val Long usr = getUsuarioIdFromLogin(headers)
		println("hoja de ruta " + hoja.id_hoja_de_ruta)

		var HojaDeRuta hdr = servicioHojasDeRutas.getById(hoja.id_hoja_de_ruta)

		if (hdr === null)
			throw new NotFoundException("La hoja de ruta " + hoja.id_hoja_de_ruta + " no existe")

		if (hdr.estado === servicioHojasDeRutas.getEstadoByNombre("Completada"))
			throw new NotFoundException("El estado de la hoja de ruta no permite su edición")

		if (hdr.remitos.forall[rto|rto.cliente.propietario.idUsuario !== usr])
			throw new UnauthorizedException("Los remitos de la hoja de ruta deben pertenecer al usuario")

		hoja.fecha_hora_inicio = hoja.fecha_hora_inicio === null ? hdr.fecha_hora_inicio : hoja.fecha_hora_inicio
		hoja.fecha_hora_fin = hoja.fecha_hora_fin === null ? hdr.fecha_hora_fin : hoja.fecha_hora_fin
		hoja.kms_recorridos = hoja.kms_recorridos === null ? hdr.kms_recorridos : hoja.kms_recorridos
		hoja.justificacion = hoja.justificacion === null ? hdr.justificacion : hoja.justificacion
		hoja.estado = hoja.estado === null ? hdr.estado : servicioHojasDeRutas.getEstadoById(hoja.estado.id_estado)
		hoja.remitos = hoja.remitos === null ? hdr.remitos : hoja.remitos

		if (hoja.estado !== servicioHojasDeRutas.getEstadoByNombre("Suspendida"))
			servicioHojasDeRutas.save(hoja)
	}

	@DeleteMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@ResponseBody
	@Transactional
	def com.unsam.pds.dominio.Generics.ResponseBody delete(
		@RequestBody @JsonView(View.HojaDeRuta.Delete) HojaDeRuta hoja, @RequestHeader HttpHeaders headers) {
		val Long usr = getUsuarioIdFromLogin(headers)
		val HojaDeRuta hdr = servicioHojasDeRutas.getById(hoja.id_hoja_de_ruta)

		if (hdr === null)
			throw new NotFoundException("La hoja de ruta " + hoja.id_hoja_de_ruta + " no existe")

		if (hdr.estado === servicioHojasDeRutas.getEstadoByNombre("Completada") ||
			hdr.estado === servicioHojasDeRutas.getEstadoByNombre("Suspendida"))
			throw new NotFoundException("El estado de la hoja de ruta no permite su edición")

		if (hdr.remitos.filter[rto|rto.cliente.propietario.idUsuario !== usr].length > 0)
			throw new UnauthorizedException("Los remitos de la hoja de ruta deben pertenecer al usuario")

		servicioHojasDeRutas.delete(hdr, hoja.justificacion)

		new com.unsam.pds.dominio.Generics.ResponseBody() => [
			code = HttpStatus.OK.toString
			message = "Hoja de ruta eliminada exitosamente"
		]
	}

	private def Specification<HojaDeRuta> joinHojaDeRutaUsuario(Specification<HojaDeRuta> spec, Long idUsuario) {
		var pr = new Specification<HojaDeRuta>() {

			override toPredicate(Root<HojaDeRuta> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
				query.distinct(true)
				var Join<Remito, HojaDeRuta> hoja = root.join("remitos")
				var Join<Cliente, Remito> rto = hoja.join("cliente")
				var Join<Usuario, Cliente> clie = rto.join("propietario")
				cb.equal(clie.get("idUsuario"), idUsuario)
			}
		}
		spec === null ? pr : pr.and(spec)
	}

}
