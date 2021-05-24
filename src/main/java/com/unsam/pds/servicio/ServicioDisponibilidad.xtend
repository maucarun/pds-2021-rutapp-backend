package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDisponibilidad
import com.unsam.pds.dominio.entidades.Disponibilidad
import javax.transaction.Transactional
import java.util.Set

@Service
class ServicioDisponibilidad {
	
	@Autowired RepositorioDisponibilidad repositorioDisponibilidad
	
	@Transactional
	def void crearNuevaDisponibilidad(Disponibilidad nuevaDisponibilidad) {
		repositorioDisponibilidad.save(nuevaDisponibilidad)
	}
	
	@Transactional
	def void crearNuevaDisponibilidades(Set<Disponibilidad> disponibilidades) {
		repositorioDisponibilidad.saveAll(disponibilidades)		
	}
	
}