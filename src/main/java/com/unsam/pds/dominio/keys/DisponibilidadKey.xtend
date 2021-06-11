package com.unsam.pds.dominio.keys

import javax.persistence.Embeddable
import java.io.Serializable
import javax.persistence.Column
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Embeddable
class DisponibilidadKey implements Serializable {
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista)
	@Column(name = "id_cliente")
	public Long idCliente
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista)
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