package com.unsam.pds.dominio.entidades

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name = "usuario")
class Usuario {
	
	@JsonView(View.Usuario.Perfil, View.Cliente.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long idUsuario
	
	@JsonView(View.Usuario.Perfil, View.Cliente.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@JsonView(View.Usuario.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String apellido
	
	@JsonView(View.Usuario.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=true)
	String username
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String password
	
	@JsonView(View.Usuario.Perfil)
	@NotNull
	@Column(length=100, nullable=false, unique=true)
	String email
	
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean activo = true
	
	new() { }
	
	def void desactivarUsuario() {
		activo = false
	}

}