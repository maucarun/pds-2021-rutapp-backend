package com.unsam.pds.dominio.Exceptions

import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.http.HttpStatus

@ResponseStatus(HttpStatus.NOT_FOUND)
class NotFoundException extends RuntimeException  {
	new() {
		super("No encontrado")
	}
	
	new(String message) {
		super(message)		
	}
}
