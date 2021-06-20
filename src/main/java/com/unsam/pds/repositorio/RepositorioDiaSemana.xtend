package com.unsam.pds.repositorio

import com.unsam.pds.dominio.entidades.DiaSemana
import org.springframework.data.repository.CrudRepository

interface RepositorioDiaSemana extends CrudRepository <DiaSemana, Long> {
	
	def DiaSemana findByDiaSemana(String diaNombre)
	
}