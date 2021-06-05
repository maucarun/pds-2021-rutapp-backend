package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Cliente
import java.util.List
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph

interface RepositorioCliente extends CrudRepository <Cliente, Long> {
	
	/* Lo usamos como testing, se puede borrar al final */
	def List<Cliente> findByPropietario_IdUsuario(Long idPropietario)
	
	def List<Cliente> findByPropietario_IdUsuarioAndActivo(Long idPropietario, Boolean estado)
	
	@EntityGraph(attributePaths=#["direccion"
		,"disponibilidades","disponibilidades.diaSemana"
		,"contactos","contactos.emails","contactos.telefonos"
	])
	def Optional<Cliente> findByIdClienteAndActivo(Long idCliente, Boolean estado)
	
	def Boolean existsByIdClienteAndPropietario_IdUsuario(Long idCliente, Long idPropietario)
	
}