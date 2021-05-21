package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import java.time.LocalDateTime
import javax.persistence.Column
import javax.validation.constraints.PositiveOrZero
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Accessors
@Entity(name="hoja_de_ruta")
class HojaDeRuta {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_hoja_de_ruta
	
	@Column(nullable=true, unique=false, name="fecha_hora_inicio")
	LocalDateTime fecha_hora_inicio
	
	@Column(nullable=true, unique=false, name="fecha_hora_fin")
	LocalDateTime fecha_hora_fin
	
	@PositiveOrZero(message="Los kms recorridos no pueden ser negativos")
	@Column(nullable=false, unique=false)
	Double kms_recorridos
	
	@Column(length=250, nullable=true, unique=false)
	String justificacion
	
	/**
	 * Un estado puede estar en muchas hdr
	 *  Una hdr tiene un solo estado
	 */
	@ManyToOne
	@JoinColumn(name="id_estado")
	EstadoHojaDeRuta estado
	
}