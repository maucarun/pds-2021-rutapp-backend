package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.keys.DisponibilidadKey
import com.unsam.pds.dominio.entidades.Disponibilidad

interface RepositorioDisponibilidad extends CrudRepository <Disponibilidad, DisponibilidadKey> {
	
}