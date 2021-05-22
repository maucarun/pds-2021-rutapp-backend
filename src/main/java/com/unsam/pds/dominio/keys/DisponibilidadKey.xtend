package com.unsam.pds.dominio.keys

import javax.persistence.Embeddable
import java.io.Serializable
import javax.persistence.Column

@Embeddable
class DisponibilidadKey implements Serializable {
	
	@Column(name = "id_cliente")
	public Long idCliente
	
	@Column(name = "id_dia_semana")
	public Long idDiaSemana

	/**
	 * Es importante crear el constructor para definir los ids
	 *  y el constructor por defecto
	 */
	new() { }
	
	new (Long _idCliente, Long _idDiaSemana) {
		idCliente = _idCliente
		idDiaSemana = _idDiaSemana
	}
	
}