package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Remito
import java.util.List
import org.springframework.data.repository.query.Param
import org.springframework.data.jpa.repository.Query
import org.springframework.data.jpa.repository.EntityGraph
import java.util.Optional

interface RepositorioRemito extends CrudRepository <Remito, Long> {
	
	@Query(value = 
	   "SELECT
			remito 
		FROM 
			remito remito
		WHERE 
			remito.cliente
		IN
		(
			select 
				cliente.idCliente 
			from 
				cliente cliente
			where 
				cliente.propietario.idUsuario = :usuarioId
		)")
	def List<Remito> findRemitosByIdUsuario (@Param("usuarioId") Long idUsuario)
	
	@EntityGraph(attributePaths=#["cliente","productos","comprobante"])
	def List<Remito> findByCliente_idClienteAndEstado_nombre(Long idCliente, String estadoPendiente)
	
	@EntityGraph(attributePaths=#["cliente","productos","productos.producto"])
	override Optional<Remito> findById(Long idRemito)
}