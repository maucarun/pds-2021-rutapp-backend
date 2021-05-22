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

@Accessors
@Entity(name="disponibilidad")
class Disponibilidad {

	@EmbeddedId
	DisponibilidadKey id_disponibilidad;

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

}
