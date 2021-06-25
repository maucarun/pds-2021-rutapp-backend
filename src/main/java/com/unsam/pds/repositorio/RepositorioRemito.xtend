package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.Remito
import java.util.List
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface RepositorioRemito extends GenericRepository<Remito, Long> {
	
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
		)"
	)
	@EntityGraph(attributePaths=#["cliente.disponibilidades.diaSemana"
		,"productosDelRemito","comprobante","estado"
	])
	def List<Remito> findRemitosByIdUsuario (@Param("usuarioId") Long idUsuario)
	
	@EntityGraph(attributePaths=#["cliente","productosDelRemito","comprobante","estado"])
	def List<Remito> findByCliente_idClienteAndEstado_nombre(Long idCliente, String estadoPendiente)
	
	@EntityGraph(attributePaths=#["cliente","productosDelRemito","productosDelRemito.producto","estado"])
	override Optional<Remito> findById(Long idRemito)
		
	override Remito getById(Long id){
		findById(id).get
	}
}