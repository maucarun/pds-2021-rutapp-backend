package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDisponibilidad
import com.unsam.pds.dominio.entidades.Disponibilidad
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.Cliente

@Service
class ServicioDisponibilidad {
	
	@Autowired RepositorioDisponibilidad repositorioDisponibilidad
	
	@Transactional
	def void crearNuevaDisponibilidad(Disponibilidad nuevaDisponibilidad) {
		repositorioDisponibilidad.save(nuevaDisponibilidad)
	}
	
	@Transactional
	def void crearNuevaDisponibilidades(Cliente cliente) {
		var disponibilidadesSinCliente = cliente.disponibilidades
		cliente.disponibilidades = newHashSet
		
		disponibilidadesSinCliente.forEach[ disponibilidad | 
			cliente.disponibilidades.add(crearDisponibilidad(disponibilidad, cliente))
		]
		repositorioDisponibilidad.saveAll(cliente.disponibilidades)
	}
	
	@Transactional
	def Disponibilidad crearDisponibilidad(Disponibilidad disponibilidad, Cliente cliente) {
		var nuevaDisponibilidad = new Disponibilidad(cliente, disponibilidad.diaSemana, disponibilidad.hora_apertura, disponibilidad.hora_cierre)
		nuevaDisponibilidad
	}
	
}