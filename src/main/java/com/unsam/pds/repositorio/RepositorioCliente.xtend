package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Cliente
import java.util.List
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph

interface RepositorioCliente extends GenericRepository<Cliente, Long> {
	
	/* Lo usamos como testing, se puede borrar al final */
	def List<Cliente> findByPropietario_IdUsuario(Long idPropietario)
	
	@EntityGraph(attributePaths=#["direccion"])
	def List<Cliente> findByPropietario_IdUsuarioAndActivo(Long idPropietario, Boolean estado)
	
	@EntityGraph(attributePaths=#["direccion"
		,"disponibilidades.diaSemana"
		,"contactos.emails","contactos.telefonos"
		,"propietario"
	])
	def Optional<Cliente> findByIdClienteAndActivo(Long idCliente, Boolean estado)
	
	def Boolean existsByIdClienteAndPropietario_IdUsuario(Long idCliente, Long idPropietario)
	
	@EntityGraph(attributePaths=#["direccion"
		,"disponibilidades.diaSemana"
		,"contactos.emails","contactos.telefonos"
		,"propietario"
	])
	override Cliente getById(Long id){
		findByIdCliente(id)
	}
	
	@EntityGraph(attributePaths=#["direccion"
		,"disponibilidades.diaSemana"
		,"contactos.emails","contactos.telefonos"
		,"propietario"
	])
	def Cliente findByIdCliente(Long id)	
}