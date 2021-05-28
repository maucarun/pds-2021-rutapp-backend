package com.unsam.pds.web.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.slf4j.LoggerFactory
import org.slf4j.Logger
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.http.MediaType
import java.util.List
import com.unsam.pds.dominio.entidades.HojaDeRuta
import org.springframework.web.bind.annotation.PathVariable
import com.unsam.pds.servicio.ServicioHojaDeRuta

@Controller
@CrossOrigin("*")
@RequestMapping("/hojaDeRuta")
class ControllerHojaDeRuta {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired ServicioHojaDeRuta servicioHojasDeRutas
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<HojaDeRuta> obtenerHojasDeRutaPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos las hojas de ruta del usuario con el id " + idUsuario)
		servicioHojasDeRutas.obtenerHojasDeRutaPorIdUsuario(idUsuario)
	}
	
}