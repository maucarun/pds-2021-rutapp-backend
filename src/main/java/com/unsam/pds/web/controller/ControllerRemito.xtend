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

@Controller
@CrossOrigin("*")
@RequestMapping("/remito")
class ControllerRemito {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired ServicioRemito servicioRemitos
	
	@GetMapping(path="/usuario/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Remito> obtenerRemitosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener todos los remitos del usuario con el id " + idUsuario)
		servicioRemitos.obtenerRemitosPorIdUsuario(idUsuario)
	}
}