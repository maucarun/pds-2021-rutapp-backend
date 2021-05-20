package com.unsam.pds.dominio

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
@Entity(name="email")
class Email {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_email
	
	@javax.validation.constraints.Email
	@Column(length=50, nullable=false, unique=false)
	String direccion
	
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean esPrincipal
	
	/**
	 * Un contacto tiene muchos emails
	 *  un email pertenece a un contacto
	 */
	@ManyToOne
	@JoinColumn(name="id_contacto")
	Contacto contacto
	
}