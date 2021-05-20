package com.unsam.pds.dominio

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Entity(name = "usuario")
class Usuario {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_usuario
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@NotNull
	@Column(length=50, nullable=false, unique=true)
	String username
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String password
	
	@NotNull
	@Column(length=100, nullable=false, unique=true)
	String email
	
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean activo
	
}