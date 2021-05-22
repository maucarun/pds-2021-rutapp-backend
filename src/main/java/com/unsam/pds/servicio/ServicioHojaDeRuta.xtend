package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioHojaDeRuta
import com.unsam.pds.dominio.entidades.HojaDeRuta

@Service
class ServicioHojaDeRuta {
	
	@Autowired RepositorioHojaDeRuta repositorioHojaDeRutas
	
	def void crearNuevaHdr(HojaDeRuta nuevaHdr) {
		repositorioHojaDeRutas.save(nuevaHdr)
	}
}