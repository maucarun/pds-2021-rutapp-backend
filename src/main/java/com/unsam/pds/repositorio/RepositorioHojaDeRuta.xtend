package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.HojaDeRuta
import java.util.List
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface RepositorioHojaDeRuta extends CrudRepository<HojaDeRuta, Long> {

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
	def List<HojaDeRuta> obtenerHojasDeRutaPorIdUsuario (@Param("usuarioId") Long idUsuario)

}
