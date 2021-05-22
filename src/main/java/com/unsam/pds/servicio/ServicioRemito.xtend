package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioRemito
import com.unsam.pds.dominio.entidades.Remito

@Service
class ServicioRemito {
	
	@Autowired RepositorioRemito repositorioRemitos
	
	def void crearNuevoRemito(Remito nuevoRemito) {
		repositorioRemitos.save(nuevoRemito)
	}
}