package com.unsam.pds.web.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.stereotype.Controller
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus
import javax.transaction.Transactional
import org.springframework.web.bind.annotation.PutMapping
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.unsam.pds.servicio.ServicioUsuario
import com.unsam.pds.dominio.entidades.Usuario
import java.time.format.DateTimeParseException
import org.springframework.web.bind.annotation.DeleteMapping
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import org.springframework.web.bind.annotation.RequestParam
//import org.apache.commons.lang3.RandomStringUtils
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.http.HttpHeaders
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.dominio.entidades.MailSender

@Controller
@CrossOrigin("*")
@RequestMapping("/usuario")
class ControllerUsuario {

	Logger logger = LoggerFactory.getLogger(ControllerUsuario)

	@Autowired ServicioUsuario servicioUsuarios

	@GetMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def boolean consultarEstadoDelBE() {
		return true;
	}
	
	@JsonView(View.Usuario.Perfil)
	@GetMapping(path="/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def Usuario obtenerUsuarioPorId(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET obtener el usuario con id " + idUsuario)
		servicioUsuarios.obtenerUsuarioPorId(idUsuario)
	}

	@JsonView(View.Usuario.Perfil)
	@PostMapping(path="/login", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@ResponseBody
	def Usuario validarUsuario(@RequestBody Usuario body) {
		servicioUsuarios.validarUsuario(body.username, body.password)
	}

	@PostMapping(path="/registrar", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@Transactional
	def void registrarUsuario(@RequestBody Usuario nuevoUsuario) {
		try {
			logger.info("POST registrar nuevo usuario")
			servicioUsuarios.crearNuevoUsuario(nuevoUsuario)
		} catch (DateTimeParseException e)
			throw new Exception("Error al registrar usuario: " + e.message)
	}

	@PutMapping(path="/{idUsuario}", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void actualizarUsuario(@PathVariable("idUsuario") Long idUsuario, @RequestBody Usuario usuarioModificado) {
		logger.info("PUT actualizar el usuario con id " + idUsuario)
		servicioUsuarios.actualizarUsuario(idUsuario, usuarioModificado)
	}

	@DeleteMapping(path="/{idUsuario}", consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@Transactional
	def void desactivarUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("DELETE desactivar el usuario con id " + idUsuario)
		servicioUsuarios.desactivarUsuario(idUsuario)
	}

	@PutMapping(path="", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	def void validarCorreoElectronico(
		@RequestParam(name="email", required=true) String email,
		@RequestHeader HttpHeaders headers) {
		logger.info("PUT /usuario?email=" + email);
		
		var user = servicioUsuarios.validarEmail(email);
//		var clave = RandomStringUtils.randomAlphanumeric(10)

		var clave = headers.containsKey("password") ? headers.get("password").get(0) : throw new UnauthorizedException()

		user.password = clave //homer@mail.com clave 1WTgtMqV
		servicioUsuarios.actualizarUsuario(user.idUsuario, user);
		var MailSender ms = new MailSender()
		ms.sendEmail(user.email, "Nueva contraseña", "Su nueva contraseña es: "+ clave)
	}
}
