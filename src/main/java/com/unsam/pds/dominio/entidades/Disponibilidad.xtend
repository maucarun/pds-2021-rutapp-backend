package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Column
import javax.persistence.ManyToOne
import javax.persistence.JoinColumn
import javax.persistence.EmbeddedId
import javax.persistence.MapsId
import com.unsam.pds.dominio.keys.DisponibilidadKey
import java.time.LocalTime
import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties("cliente")
@Accessors
@Entity(name="disponibilidad")
class Disponibilidad {

	@EmbeddedId
	DisponibilidadKey idDisponibilidad;

	@ManyToOne
	@MapsId("idCliente")
	@JoinColumn(name="id_cliente")
	Cliente cliente

	@ManyToOne
	@MapsId("idDiaSemana")
	@JoinColumn(name="id_dia_semana")
	DiaSemana diaSemana

	@Column(nullable=false, unique=false)
	LocalTime hora_apertura

	@Column(nullable=false, unique=false)
	LocalTime hora_cierre

	new() { }
	
	/**
	 * Es importante tener este constructor para definir el ID
	 *  ya que hibernate no puede hacer el seter id por reflection
	 */
	new(Cliente _cliente, DiaSemana _dia, LocalTime _hora_apertura, LocalTime _hora_cierre) {
		idDisponibilidad = new DisponibilidadKey(_cliente.getIdCliente, _dia.id_dia_semana)
		cliente = _cliente
		diaSemana = _dia
		hora_apertura = _hora_apertura
		hora_cierre = _hora_cierre
	}
	
}
