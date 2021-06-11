package com.unsam.pds.dominio.Generics

import com.unsam.pds.dominio.Exceptions.NotFoundException
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.dominio.entidades.Estado
import com.unsam.pds.servicio.ServicioEstado
import com.unsam.pds.servicio.ServicioUsuario
import javax.persistence.criteria.CriteriaBuilder
import javax.persistence.criteria.CriteriaQuery
import javax.persistence.criteria.Root
import javax.servlet.http.HttpServletRequest
import org.hibernate.exception.ConstraintViolationException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.jpa.domain.Specification
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.context.request.WebRequest

abstract class GenericController<T> {
	@Autowired ServicioUsuario servusr

	/**
	 * Método que devuelve el id del usuario a partir de las credenciales
	 * de acceso que proporciono al invocar el servicio.-
	 * @param headers Cabecera de la solicitud
	 * @return Id del usuario logueado
	 */
	def Long getUsuarioIdFromLogin(HttpHeaders headers) {
		var usrName = headers.containsKey("usuario") ? headers.get("usuario").get(0) : throw new UnauthorizedException()
		var pass = headers.containsKey("password") ? headers.get("password").get(0) : throw new UnauthorizedException()
		println("Password: " + pass)
		servusr.validar(usrName, pass)
	}

	def Specification<T> AgregarFiltro(Specification<T> spec, String field, Object value) {

		var pr = new Specification<T> {
			override toPredicate(Root<T> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
				criteriaBuilder.equal(root.<Long>get(field), value)
			}
		}

		spec === null ? pr : pr.and(spec)
	}

	def static <T extends Estado> Estado obtenerEstado(String estado) {
		ServicioEstado.getByNombre(estado) as T
	}

	@ExceptionHandler(typeof(NotFoundException))
	@ResponseStatus(HttpStatus.NOT_FOUND)
	def ResponseEntity<ResponseBody> handleNoSuchElementFoundException(
		NotFoundException exception,
		HttpServletRequest request,
		Model model
	) {
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ResponseBody() => [
			code = HttpStatus.NOT_FOUND.toString
			message = exception.message
		])
	}

	@ExceptionHandler(typeof(UnauthorizedException))
	@ResponseStatus(HttpStatus.UNAUTHORIZED)
	def ResponseEntity<ResponseBody> handleUnauthorizedException(
		UnauthorizedException exception,
		HttpServletRequest request,
		Model model
	) {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ResponseBody() => [
			code = HttpStatus.UNAUTHORIZED.toString
			message = exception.message
		])
	}

	@ExceptionHandler(ConstraintViolationException)
	def ResponseEntity<ResponseBody> handleConstraintViolation(ConstraintViolationException ex, WebRequest request) {
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
			new ResponseBody() => [code = HttpStatus.BAD_REQUEST.toString message = ex.cause.initCause(ex).message]
		)
	}
}
