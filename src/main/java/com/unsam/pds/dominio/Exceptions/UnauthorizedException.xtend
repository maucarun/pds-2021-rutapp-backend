package com.unsam.pds.dominio.Exceptions

import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus

@ResponseStatus(HttpStatus.UNAUTHORIZED)
class UnauthorizedException extends RuntimeException  {
	new() {
		super("Usuario no autorizado")
	}
	
	new(String message) {
		super(message)		
	}
}
