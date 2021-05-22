package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDisponibilidad
import com.unsam.pds.dominio.entidades.Disponibilidad

@Service
class ServicioDisponibilidad {
	
	@Autowired RepositorioDisponibilidad repositorioDisponibilidad
	
	def void crearNuevaDisponibilidad(Disponibilidad nuevaDisponibilidad) {
		repositorioDisponibilidad.save(nuevaDisponibilidad)
	}
}