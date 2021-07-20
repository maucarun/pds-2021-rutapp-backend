package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.ProductoRemito
import com.unsam.pds.dominio.keys.ProductoRemitoKey
import org.springframework.data.jpa.repository.Query
import java.util.List
import org.springframework.data.repository.query.Param
import java.time.LocalDate
import com.unsam.pds.repositorio.projectionQueries.IReporteCantidadProductosEntregados
import com.unsam.pds.repositorio.projectionQueries.IReporteCantidadProductosVendidos

interface RepositorioProductoRemito extends CrudRepository<ProductoRemito, ProductoRemitoKey> {

	def void deleteByRemito_idRemito(Long idRemito)

/* 
 * Esta query esta armada sin native query 
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
		@EntityGraph(attributePaths=#["producto"])
*/
	@Query(value=
		"select 
		      id_producto as idProducto
			, (select nombre from rutapp_db.producto where id_producto = pr.id_producto) as nombreProducto
			, sum(pr.cantidad) as cantidad
		from 
			rutapp_db.producto_remito as pr
		where
			pr.id_remito
		in
		(
			select 
				id_remito
			from 
				rutapp_db.remito
			where 
				id_cliente
			in
		    (
				select 
					id_cliente 
				from 
					rutapp_db.cliente 
				where 
					id_usuario = :usuarioId
		    )
		)
		and
			pr.id_remito
		in
		(
			select
				id_remito
			from
				rutapp_db.remito
			where
				id_estado = 7
		)
		and
			pr.id_remito
		in
		(
			select
				id_remito
			from
				rutapp_db.remito
			where
				fecha_de_creacion between :fecha_desde and :fecha_hasta
		)
		group by idProducto, nombreProducto", nativeQuery = true)
	def List<IReporteCantidadProductosVendidos> findByCantidadProductosVendidos(
		  @Param("usuarioId") Long idUsuario
		, @Param("fecha_desde") LocalDate fechaDesde
		, @Param("fecha_hasta") LocalDate fechaHasta
	)
	
	@Query(value=
		"select
			  id_producto as idProducto
			, (select nombre from rutapp_db.producto where id_producto = pr.id_producto) as nombreProducto
			, count(id_producto) as cantidad
		    , (select nombre from rutapp_db.cliente where id_cliente = (select id_cliente from rutapp_db.remito where id_remito = pr.id_remito)) as nombreCliente
		from 
			rutapp_db.producto_remito as pr
		where
			pr.id_remito
		in
		(
			select 
				id_remito
			from 
				rutapp_db.remito
			where 
				id_cliente
			in
		    (
				select 
					id_cliente 
				from 
					rutapp_db.cliente 
				where 
					id_usuario= :usuarioId
		    )
		)
		and
			pr.id_remito
		in
		(
			select
				id_remito
			from
				rutapp_db.remito
			where
				id_estado = 7
		)
		and
			pr.id_remito
		in
		(
			select
				id_remito
			from
				rutapp_db.remito
			where
				fecha_de_creacion between :fecha_desde and :fecha_hasta
		)
		group by id_producto, nombreProducto, nombreCliente", nativeQuery = true)
	/*
	 * No funciona el entityGraph con nativeQuery 
	 *  nativeQuery mejora la performance de la query en la db
	@EntityGraph(attributePaths=#["producto", "remito.cliente"])
	 */
	def List<IReporteCantidadProductosEntregados> findByCantidadProductosEntregados(
		  @Param("usuarioId") Long idUsuario 
		, @Param("fecha_desde") LocalDate fechaDesde
		, @Param("fecha_hasta") LocalDate fechaHasta
	)

}
