package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.HojaDeRuta
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import java.util.Optional
import org.springframework.lang.Nullable
import org.springframework.data.jpa.domain.Specification
import com.unsam.pds.repositorio.projectionQueries.IReporteInfoHojaDeRuta

interface RepositorioHojaDeRuta extends GenericRepository<HojaDeRuta, Long> {

	/**
	 * En las JPQL tenemos que poner el nombre de la tabla.
	 * Esto es porque le definimos el nombre a las tablas
	 *  en el @Entity
	 */
	@Query(value = 
		"SELECT 
			hojaDeRuta 
		 FROM 
			hoja_de_ruta hojaDeRuta
		WHERE 
			hojaDeRuta.id_hoja_de_ruta
		IN
		(
			select
				remito.hojaDeRuta 
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
		)")
	@EntityGraph(attributePaths=#["estado"])
	def List<HojaDeRuta> obtenerHojasDeRutaPorIdUsuario (@Param("usuarioId") Long idUsuario)

	@Query(value = "SELECT * FROM hoja_de_ruta WHERE id_hoja_de_ruta=?1", nativeQuery = true)
	override HojaDeRuta getById(Long id)
	
	@Query(value="
		SELECT 
			  id_hoja_de_ruta as idHojaDeRuta
			, fecha_hora_inicio as fechaHoraInicio
		    , kms_recorridos as kmsRecorridos
		    , (select nombre from rutapp_db.estado where id_estado = hdr.id_estado) as estado
		    , (select count(*) from rutapp_db.remito where id_hoja_de_ruta = hdr.id_hoja_de_ruta ) as cantidadClientes
		    , (select count(*) from rutapp_db.remito where id_hoja_de_ruta = hdr.id_hoja_de_ruta and (id_estado = 7 or id_estado = 5)) as cantidadClientesVisitados
		    , (select count(*) from rutapp_db.producto_remito where id_remito in (select id_remito from rutapp_db.remito where id_hoja_de_ruta = hdr.id_hoja_de_ruta)) as cantidadProductosEntregados
		    , (select avg(tiempo_espera) from rutapp_db.remito where id_hoja_de_ruta = hdr.id_hoja_de_ruta ) as promedioEntrega
		FROM 
			rutapp_db.hoja_de_ruta as hdr
		WHERE 
			id_hoja_de_ruta
		IN
		(
			select 
				id_hoja_de_ruta 
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
					id_usuario=:usuarioId
			)
		)", nativeQuery = true)
	def List<IReporteInfoHojaDeRuta> obtenerInfoHojasDeRutaPorUsuario(@Param("usuarioId") Long idUsuario) 
	
	@EntityGraph(attributePaths=#["estado.nombre",
		"estado.id_estado",
		"remitos.idRemito",
		"remitos.estado.nombre",
		"remitos.estado.id_estado",
		"remitos.cliente.nombre",
		"remitos.cliente.direccion.calle",
		"remitos.cliente.direccion.altura",
		"remitos.cliente.direccion.localidad",
		"remitos.cliente.direccion.provincia",
		"remitos.cliente.direccion.latitud",
		"remitos.cliente.direccion.longitud",
		"remitos.productosDelRemito",
		"remitos.cliente.disponibilidades.diaSemana.id_dia_semana",
		"remitos.cliente.disponibilidades.diaSemana.diaSemana"])
	override Optional<HojaDeRuta> findOne(@Nullable Specification<HojaDeRuta> spec);
}
