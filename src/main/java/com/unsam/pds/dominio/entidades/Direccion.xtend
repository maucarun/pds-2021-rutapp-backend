package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import javax.validation.constraints.Positive
import javax.persistence.OneToOne
import com.fasterxml.jackson.annotation.JsonIgnore

@Accessors
@Entity(name="direccion")
class Direccion {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_direccion
	
	@NotNull
	@Column(length=250, nullable=false, unique=false)
	String calle
	
	@Positive(message="La altura debe ser positiva")
	@Column(nullable=false, unique=false)
	Integer altura
	
	@NotNull
	@Column(length=100, nullable=false, unique=false)
	String localidad
	
	@NotNull
	@Column(length=100, nullable=false, unique=false)
	String provincia
	
	/**
	 * Latitud y Longitud pueden ser negativas
	 */
	@NotNull
	@Column(nullable=false, unique=false)
	Double latitud
	
	@NotNull
	@Column(nullable=false, unique=false)
	Double longitud
	
	@OneToOne(mappedBy = "direccion")
	@JsonIgnore
	Cliente cliente
	
	new() { }
	
}