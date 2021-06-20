package com.unsam.pds.repositorio

import com.unsam.pds.dominio.Generics.GenericRepository
import com.unsam.pds.dominio.entidades.HojaDeRuta
import java.util.List
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

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
}
