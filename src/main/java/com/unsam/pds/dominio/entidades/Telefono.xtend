package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Column
import javax.validation.constraints.NotNull
import javax.persistence.JoinColumn
import javax.validation.constraints.Min
import javax.persistence.ManyToOne

@Accessors
@Entity(name="telefono")
class Telefono {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_email
	
	@Min(value=8)
	@Column(length=20, nullable=false, unique=false)
	String telefono
	
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean esPrincipal
	
	/**
	 * Un contacto tiene muchos telefonos
	 *  un telefono pertenece a un contacto
	 */
	@ManyToOne
	@JoinColumn(name="id_contacto")
	Contacto contacto
	
}