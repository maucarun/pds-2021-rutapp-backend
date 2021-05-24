package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioCliente
import com.unsam.pds.dominio.entidades.Cliente
import javax.transaction.Transactional
import java.util.List
import javassist.NotFoundException

@Service
class ServicioCliente {
	
	@Autowired RepositorioCliente repositorioClientes
	
	@Autowired ServicioContacto servicioContactos
	@Autowired ServicioDisponibilidad servicioDisponibilidad
	@Autowired ServicioUsuario servicioUsuario
	
	def List<Cliente> obtenerClientesPorUsuario(Long idUsuario) {
		var usuario = servicioUsuario.obtenerUsuarioPorId(idUsuario)
		repositorioClientes.findByPropietario(usuario)
	}
	
	def Cliente obtenerClienteDelUsuarioPorId(Long idCliente, Long idUsuario) {
		var cliente = obtenerClientePorId(idCliente)
		if (cliente.propietario.id_usuario != idUsuario)
			throw new RuntimeException("El cliente " + cliente.nombre + " no pertenece al usuario " + idUsuario)
		cliente		
	}
	
	def Cliente obtenerClientePorId(Long idCliente) {
		repositorioClientes.findById(idCliente).orElseThrow([
			throw new NotFoundException("No existe el cliente con el id " + idCliente)
		])
	}
	
	@Transactional
	def void crearNuevoCliente(Cliente nuevoCliente) {
		repositorioClientes.save(nuevoCliente)
		
//		servicioContactos.crearNuevosContactos(nuevoCliente)
		
		servicioDisponibilidad.crearNuevaDisponibilidades(nuevoCliente)
	}
	
	@Transactional
	def void actualizarCliente(Cliente clienteModificado, Long idCliente, Long idUsuario) {
		
		repositorioClientes.save(clienteModificado)
		
		//servicioContactos.crearNuevosContactos(clienteModificado)
		//servicioContactos.actualizarContactos(clienteAModificar.contactos)
		
		servicioDisponibilidad.crearNuevaDisponibilidades(clienteModificado)
		//servicioDisponibilidad.actualizarDisponibilidades(clienteAModificar)
	}
	
}