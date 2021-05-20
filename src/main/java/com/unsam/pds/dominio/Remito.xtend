package com.unsam.pds.dominio

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Column
import java.time.LocalDate
import javax.validation.constraints.PositiveOrZero
import java.sql.Time
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Accessors
@Entity(name="remito")
class Remito {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_remito
	
	@Column(nullable=false, unique=false)
	LocalDate fecha
	
	@PositiveOrZero(message="El total no puede ser negativo")
	@Column(nullable=false, unique=false)
	Double total
	
	@Column(length=250, nullable=true, unique=false)
	String motivo
	
	@PositiveOrZero(message="El tiempo no puede ser negativo")
	@Column(nullable=false, unique=false)
	Time tiempo_espera
	
	/**
	 * Un cliente puede tener muchos remitos
	 *  Un remito pertenece a un solo cliente
	 */
	@ManyToOne
	@JoinColumn(name="id_cliente")
	Cliente cliente
	
	/**
	 * Un estado puede estar en muchos remitos
	 *  Un remito tiene un solo estado
	 */
	@ManyToOne
	@JoinColumn(name="id_estado")
	EstadoRemito estado
	
	/**
	 * Un remito pertenece a una hdr
	 *  una hdr puede tener muchos remitos
	 */
	@ManyToOne
	@JoinColumn(name="id_hoja_de_ruta")
	HojaDeRuta hojaDeRuta
	
}