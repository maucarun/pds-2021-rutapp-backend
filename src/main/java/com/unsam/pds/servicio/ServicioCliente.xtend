package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioCliente
import com.unsam.pds.dominio.entidades.Cliente
import javax.transaction.Transactional
import java.util.List

@Service
class ServicioCliente {
	
	@Autowired RepositorioCliente repositorioClientes
	
	@Autowired ServicioUsuario servicioUsuario
	
	def List<Cliente> obtenerClientesPorUsuario(Long idUsuario) {
		var usuario = servicioUsuario.obtenerUsuarioPorId(idUsuario)
		repositorioClientes.findByPropietario(usuario)
	}
	
	@Transactional
	def void crearNuevoCliente(Cliente nuevoCliente) {
		repositorioClientes.save(nuevoCliente)
	}
}