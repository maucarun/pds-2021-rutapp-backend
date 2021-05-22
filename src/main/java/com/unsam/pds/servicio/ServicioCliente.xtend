package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioCliente
import com.unsam.pds.dominio.entidades.Cliente

@Service
class ServicioCliente {
	
	@Autowired RepositorioCliente repositorioClientes
	
	def void crearNuevoCliente(Cliente nuevoCliente) {
		repositorioClientes.save(nuevoCliente)
	}
}