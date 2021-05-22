package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDireccion
import com.unsam.pds.dominio.entidades.Direccion

@Service
class ServicioDireccion {
	
	@Autowired RepositorioDireccion repositorioDirecciones
	
	def void crearNuevaDireccion(Direccion nuevaDireccion) {
		repositorioDirecciones.save(nuevaDireccion)
	}
}