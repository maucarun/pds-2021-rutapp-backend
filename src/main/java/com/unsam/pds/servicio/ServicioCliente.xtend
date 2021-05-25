package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioCliente
import com.unsam.pds.dominio.entidades.Cliente
import javax.transaction.Transactional
import java.util.List
import javassist.NotFoundException
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@Service
class ServicioCliente {
	
	Logger logger = LoggerFactory.getLogger(ServicioCliente)
	
	
	@Autowired RepositorioCliente repositorioClientes
	
//	@Autowired ServicioContacto servicioContactos
	@Autowired ServicioDisponibilidad servicioDisponibilidad
	
	def Cliente obtenerClientePorId(Long idCliente) {
		logger.info("Obtener el cliente con el " + idCliente)
		repositorioClientes.findById(idCliente).orElseThrow([
			throw new NotFoundException("No existe el cliente con el id " + idCliente)
		])
	}
	
	def List<Cliente> obtenerClientesPorUsuario(Long idUsuario) {
		logger.info("Obteniendo los clientes para el usuario id " + idUsuario)
		repositorioClientes.findByPropietario_IdUsuario(idUsuario)
	}
	
	/** Devuelve true si el idUsuario pertenece al idCliente */
	def Boolean validarClienteDelUsuarioPorId(Long idCliente, Long idUsuario) {
		logger.info("Validando si el cliente id " + idCliente + " tiene de al propietario id " + idUsuario)
		repositorioClientes.existsByIdClienteAndPropietario_IdUsuario(idCliente, idUsuario)
	}
	
	/** 
	 * Valida que el cliente tenga a ese propietario y 
	 *  retorna el cliente
	 */
	def Cliente obtenerClienteDelUsuarioPorId(Long idCliente, Long idUsuario) {
		if (!validarClienteDelUsuarioPorId(idCliente, idUsuario))
			throw new RuntimeException("El cliente con id " + idCliente + " no pertenece al usuario con id " + idUsuario)
		obtenerClientePorId(idCliente)
	}
	
	
	@Transactional
	def void crearNuevoCliente(Cliente nuevoCliente) {
		logger.info("Creando al cliente con el nombre " + nuevoCliente.nombre)
		repositorioClientes.save(nuevoCliente)
		
		servicioDisponibilidad.crearNuevaDisponibilidades(nuevoCliente)
		logger.info("Cliente creado exitosamente!")
	}
	
	@Transactional
	def void actualizarCliente(Cliente clienteModificado, Long idCliente, Long idUsuario) {
		logger.info("Actualizando el cliente id " + idCliente)
		obtenerClienteDelUsuarioPorId(idCliente, idUsuario)
		
		crearNuevoCliente(clienteModificado)
		logger.info("Cliente actualizado exitosamente!")
	}
	
}