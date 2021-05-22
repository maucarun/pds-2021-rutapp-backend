package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.HojaDeRuta

interface RepositorioHojaDeRuta extends CrudRepository <HojaDeRuta, Long> {
	
}