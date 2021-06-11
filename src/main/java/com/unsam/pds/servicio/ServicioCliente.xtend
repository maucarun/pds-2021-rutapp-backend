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
import com.unsam.pds.dominio.Generics.GenericService

@Service
class ServicioCliente extends GenericService<Cliente, Long> {
	
	Logger logger = LoggerFactory.getLogger(this.class)
	
	@Autowired RepositorioCliente repo
	
	@Autowired ServicioDisponibilidad servicioDisponibilidad
	
	def Cliente obtenerClienteActivoPorId(Long idCliente) {
		logger.info("Obtener el id cliente " + idCliente)
		repo.findByIdClienteAndActivo(idCliente, true).orElseThrow([
			throw new NotFoundException("No existe el cliente con el id " + idCliente)
		])
	}
	
	def List<Cliente> obtenerClientesPorIdUsuario(Long idUsuario) {
		logger.info("Obteniendo los clientes activos para el usuario id " + idUsuario)
		repo.findByPropietario_IdUsuario(idUsuario)
	}
	
	def List<Cliente> obtenerClientesActivosPorUsuario(Long idUsuario) {
		logger.info("Obteniendo los clientes activos para el usuario id " + idUsuario)
		repo.findByPropietario_IdUsuarioAndActivo(idUsuario, true)
	}
	
	/** Devuelve true si el idUsuario pertenece al idCliente */
	def Boolean validarClienteDelUsuarioPorId(Long idCliente, Long idUsuario) {
		logger.info("Validando si el cliente id " + idCliente + " tiene de al propietario id " + idUsuario)
		repo.existsByIdClienteAndPropietario_IdUsuario(idCliente, idUsuario)
	}
	
	/** 
	 * Valida que el cliente tenga a ese propietario y que esté activo 
	 * Retorna el cliente
	 */
	def Cliente obtenerClienteActivoDelUsuarioPorId(Long idCliente, Long idUsuario) {
		if (!validarClienteDelUsuarioPorId(idCliente, idUsuario))
			throw new RuntimeException("El cliente con id " + idCliente + " no pertenece al usuario con id " + idUsuario)
		
		obtenerClienteActivoPorId(idCliente)
	}
	
	@Transactional
	def void crearNuevoCliente(Cliente nuevoCliente) {
		logger.info("Creando al cliente con el nombre " + nuevoCliente.nombre)
		repo.save(nuevoCliente)
		
		servicioDisponibilidad.crearNuevaDisponibilidades(nuevoCliente)
		logger.info("Cliente creado exitosamente!")
	}
	
	@Transactional
	def void actualizarCliente(Cliente clienteModificado, Long idCliente, Long idUsuario) {
		logger.info("Actualizando el cliente id " + idCliente)
		obtenerClienteActivoDelUsuarioPorId(idCliente, idUsuario)
		
		crearNuevoCliente(clienteModificado)
		logger.info("Cliente actualizado exitosamente!")
	}
	
	@Transactional
	def void desactivarCliente(Long idCliente, Long idUsuario) {
		var cliente = obtenerClienteActivoDelUsuarioPorId(idCliente, idUsuario)
		cliente.desactivarCliente
		logger.info("Cliente desactivado exitosamente!")
	}
	
}