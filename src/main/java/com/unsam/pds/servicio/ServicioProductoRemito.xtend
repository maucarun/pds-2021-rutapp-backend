package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioProductoRemito
import com.unsam.pds.dominio.entidades.ProductoRemito

@Service
class ServicioProductoRemito {
	
	@Autowired RepositorioProductoRemito repositorioProductoRemitos
	
	def void crearNuevoProductoRemito(ProductoRemito nuevoPR) {
		repositorioProductoRemitos.save(nuevoPR)
	}
}