package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDisponibilidad
import com.unsam.pds.dominio.entidades.Disponibilidad
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.Cliente
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@Service
class ServicioDisponibilidad {
	
	Logger logger = LoggerFactory.getLogger(ServicioDisponibilidad)
	
	
	@Autowired RepositorioDisponibilidad repositorioDisponibilidad
	
	@Transactional
	def void eliminarDisponibilidadPorCliente(Long idCliente) {
		logger.info("Eliminando las disponibilidades del cliente id " + idCliente)
		repositorioDisponibilidad.deleteByCliente_idCliente(idCliente)
	}
	
	@Transactional
	def void crearNuevaDisponibilidad(Disponibilidad nuevaDisponibilidad) {
		logger.info("Creando la disponibilidad del dia " + nuevaDisponibilidad.diaSemana.diaSemana 
			+ " para el cliente " + nuevaDisponibilidad.cliente.nombre)
		repositorioDisponibilidad.save(nuevaDisponibilidad)
		logger.info("Disponibilidad creada exitosamente!")
	}
	
	@Transactional
	def void crearNuevaDisponibilidades(Cliente cliente) {
		logger.info("Creando las disponibilidades para el cliente " + cliente.nombre)
		var disponibilidadesSinCliente = cliente.disponibilidades
		cliente.disponibilidades = newHashSet
		
		disponibilidadesSinCliente.forEach[ disponibilidad | 
			cliente.disponibilidades.add(crearDisponibilidad(disponibilidad, cliente))
		]
		
		eliminarDisponibilidadPorCliente(cliente.idCliente)
		repositorioDisponibilidad.saveAll(cliente.disponibilidades)
		logger.info("Disponibilidades creadas exitosamente!")
	}
	
	@Transactional
	private def Disponibilidad crearDisponibilidad(Disponibilidad disponibilidad, Cliente cliente) {
		logger.info("Creando la disponibilidad para el cliente " + cliente.nombre 
			+ " el dia " + disponibilidad.diaSemana.diaSemana)
		new Disponibilidad(cliente, disponibilidad.diaSemana, disponibilidad.hora_apertura, disponibilidad.hora_cierre)
	}
	
}