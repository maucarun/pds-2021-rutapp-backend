package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDiaSemana
import com.unsam.pds.dominio.entidades.DiaSemana

@Service
class ServicioDiaSemana {
	
	@Autowired RepositorioDiaSemana repositorioDiasSemana
	
	def void crearNuevoDia(DiaSemana nuevoDia) {
		repositorioDiasSemana.save(nuevoDia)
	}
	
	def DiaSemana obtenerDiaPorNombre(String diaNombre) {
		repositorioDiasSemana.findByDiaSemana(diaNombre)
	}
	
}