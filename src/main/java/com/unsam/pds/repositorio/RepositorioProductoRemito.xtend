package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.ProductoRemito
import com.unsam.pds.dominio.keys.ProductoRemitoKey
import org.springframework.data.jpa.repository.Query
import java.util.List
import org.springframework.data.repository.query.Param
import java.time.LocalDate
import org.springframework.data.jpa.repository.EntityGraph

interface RepositorioProductoRemito extends CrudRepository<ProductoRemito, ProductoRemitoKey> {

	def void deleteByRemito_idRemito(Long idRemito)

	@Query(value="
		SELECT 
      		  pr
			, sum(pr.cantidad)
		FROM 
			producto_remito pr
		WHERE
			pr.remito
		IN
		(
			select 
				remito.idRemito
			from 
				remito remito
			where 
				remito.cliente
			in
		    (
				select 
					cliente.idCliente 
				from 
					cliente cliente 
				where 
					cliente.propietario.idUsuario = :usuarioId
		    )
		)
		AND
			pr.remito
		IN
		(
			select
				remito.idRemito
			from
				remito remito
			where
				remito.estado.id_estado = 7
		)
		AND
			pr.remito
		IN
		(
			select
				remito.idRemito
			from
				remito remito
			where
				remito.fechaDeCreacion between :fecha_desde and :fecha_hasta
		)
		GROUP BY pr")
	@EntityGraph(attributePaths=#["producto"
	])
	def List<ProductoRemito> findByIdUsuarioAndFechaDesdeAndFechaHasta(
		  @Param("usuarioId") Long idUsuario
		, @Param("fecha_desde") LocalDate fechaDesde
		, @Param("fecha_hasta") LocalDate fechaHasta
	)

}
