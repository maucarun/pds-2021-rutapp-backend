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
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import javax.persistence.FetchType

@Accessors
@Entity(name="email")
class Email {
	
	@JsonView(View.Cliente.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_email
	
	@JsonView(View.Cliente.Perfil)
	@javax.validation.constraints.Email
	@Column(length=50, nullable=false, unique=false)
	String direccion
	
	@JsonView(View.Cliente.Perfil)
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean esPrincipal
	
	/**
	 * Un contacto tiene muchos emails
	 *  un email pertenece a un contacto
	 */
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_contacto", nullable=false)
	@JsonIgnore
	Contacto contacto
	
	new() { }
	
}