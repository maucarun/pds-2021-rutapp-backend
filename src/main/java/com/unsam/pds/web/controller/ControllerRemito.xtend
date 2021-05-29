package com.unsam.pds.web.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.servicio.ServicioRemito
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.ResponseBody
import java.util.List
import com.unsam.pds.dominio.entidades.Remito
import org.springframework.web.bind.annotation.PathVariable
import com.unsam.pds.servicio.ServicioCliente

@Controller
@CrossOrigin("*")
@RequestMapping("/remito")
class ControllerRemito {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired ServicioRemito servicioRemitos
	
	@Autowired ServicioCliente servicioClientes
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerRemitosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos los remitos del usuario con el id " + idUsuario)
		servicioRemitos.obtenerRemitosPorIdUsuario(idUsuario)
	}
	
	/**
	 * BE - servicio - obtener los remitos con estado pendiente por cliente
	 */
	@GetMapping(path="/pendiente/usuario/{idUsuario}/cliente/{idCliente}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerRemitosPendientesPorCliente(
		  @PathVariable("idUsuario") Long idUsuario
		, @PathVariable("idCliente") Long idCliente
	) {
		logger.info("GET obtener todos los remitos pendientes del usuario id " + idUsuario + " del cliente id " + idCliente)
		servicioClientes.obtenerClienteActivoDelUsuarioPorId(idCliente, idUsuario)	
		servicioRemitos.obtenerRemitosPendientesPorIdCliente(idCliente)
	}
}