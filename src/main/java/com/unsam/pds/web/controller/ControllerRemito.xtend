package com.unsam.pds.web.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
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
import com.unsam.pds.servicio.ServicioRemito
import com.unsam.pds.dominio.entidades.Remito
import org.springframework.web.bind.annotation.RequestParam
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Controller
@CrossOrigin("*")
@RequestMapping("/remito")
class ControllerRemito {
	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioRemito servicioRemito

	// GET ALL REMITOS por id usuario
//	@GetMapping(path="/all/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	def List<Remito> obtenerTodosLosRemitosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
//		logger.info("GET localhost:8080/remito/all/" + idUsuario)
//		servicioRemito.obtenerRemitosPorIdUsuario(idUsuario)
//	}

	// GET REMITOS por id cliente y estado pendiente
	@JsonView(View.Remito.Lista)
	@GetMapping(path="/all", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerRemito(@RequestParam("idCliente") Long idCliente, @RequestParam("estado") String estado) {
		logger.info("GET localhost:8080/all?" + idCliente+ "&estado="+estado)
		servicioRemito.obtenerRemitosPendientesPorIdCliente(idCliente)
	}
	
	// GET REMITO por id remito
	@JsonView(View.Remito.Perfil)
	@GetMapping(path="/{idRemito}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Remito obtenerRemito(@PathVariable("idRemito") Long idRemito) {
		logger.info("GET localhost:8080/" + idRemito)
		servicioRemito.obtenerRemitoPorId(idRemito)
	}

	// POST REMITO
	@PostMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void crearRemito(@RequestBody Remito remito) {
		logger.info("POST localhost:8080/" + remito)
		servicioRemito.actualizarOCrearRemito(remito)
	}

	// PUT REMITO
	@PutMapping(path="", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarRemito(@RequestBody Remito remito) {
		logger.info("PUT localhost:8080/" + remito)
		servicioRemito.actualizarOCrearRemito(remito)
	}

}
