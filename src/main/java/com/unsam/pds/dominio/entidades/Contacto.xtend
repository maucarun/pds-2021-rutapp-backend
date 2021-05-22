package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Accessors
@Entity(name="contacto")
class Contacto {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_contacto
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String apellido
	
	/**
	 * Un cliente tiene muchos contactos
	 *  un contacto pertenece a un cliente
	 */
	@ManyToOne
	@JoinColumn(name="id_cliente")
	Cliente cliente
	
	new() { }
}