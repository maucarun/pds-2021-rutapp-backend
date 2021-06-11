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
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import javax.persistence.FetchType

@JsonIgnoreProperties("cliente")
@Accessors
@Entity(name="disponibilidad")
class Disponibilidad {

	@JsonView(View.Cliente.Perfil, View.Cliente.Lista)
	@EmbeddedId
	DisponibilidadKey idDisponibilidad;

	@ManyToOne(fetch=FetchType.LAZY)
	@MapsId("idCliente")
	@JoinColumn(name="id_cliente")
	Cliente cliente

	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post)
	@ManyToOne(fetch=FetchType.LAZY)
	@MapsId("idDiaSemana")
	@JoinColumn(name="id_dia_semana")
	DiaSemana diaSemana

	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post)
	@Column(nullable=false, unique=false)
	LocalTime hora_apertura
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post)
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
	
	def String dia() {
		diaSemana.dia_semana
	}
	
}
