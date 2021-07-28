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
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import javax.persistence.FetchType

@Accessors
@Entity(name="telefono")
class Telefono {
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.HojaDeRuta.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_telefono
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Perfil, View.HojaDeRuta.Perfil)
	@Min(value=8)
	@Column(length=20, nullable=false, unique=false)
	String telefono
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post)
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean esPrincipal = true
	
	/**
	 * Un contacto tiene muchos telefonos
	 *  un telefono pertenece a un contacto
	 */
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_contacto", nullable=false)
	@JsonIgnore
	Contacto contacto
	
	new() { }
	
	def void setContacto(Contacto _contacto) {
		_contacto.agregarTelefono(this)
		contacto = _contacto
	}
}