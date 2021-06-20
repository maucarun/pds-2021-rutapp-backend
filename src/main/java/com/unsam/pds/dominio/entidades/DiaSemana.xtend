package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name="dia_semana")
class DiaSemana {
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.HojaDeRuta.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_dia_semana
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.HojaDeRuta.Perfil)
	@NotNull
	@Column(length=12, nullable=false, unique=true)
	String diaSemana
	
	new() { }	
}