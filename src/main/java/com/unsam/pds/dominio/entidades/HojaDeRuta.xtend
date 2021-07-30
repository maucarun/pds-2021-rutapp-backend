package com.unsam.pds.dominio.entidades

import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import java.time.LocalDateTime
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import javax.validation.constraints.PositiveOrZero
import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.CascadeType

@Accessors
@Entity(name="hoja_de_ruta")
class HojaDeRuta {
	
	@JsonView(View.HojaDeRuta.Lista, View.HojaDeRuta.Perfil, View.HojaDeRuta.Delete, View.HojaDeRuta.Put, View.Remito.Post, View.Remito.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_hoja_de_ruta
	
	@JsonView(View.HojaDeRuta.Lista, View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@Column(nullable=true, unique=false, name="fecha_hora_inicio")
	LocalDateTime fecha_hora_inicio
	
	@JsonView(View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@Column(nullable=true, unique=false, name="fecha_hora_fin")
	LocalDateTime fecha_hora_fin
	
	@JsonView(View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@PositiveOrZero(message="Los kms recorridos no pueden ser negativos")
	@Column(nullable=false, unique=false)
	Double kms_recorridos
	
	@JsonView(View.HojaDeRuta.Perfil, View.HojaDeRuta.Post, View.HojaDeRuta.Delete)
	@Column(length=250, nullable=true, unique=false)
	String justificacion
	
	/**
	 * Un estado puede estar en muchas hdr
	 *  Una hdr tiene un solo estado
	 */
 	@JsonView(View.HojaDeRuta.Lista, View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@ManyToOne
	@JoinColumn(name="id_estado")
	EstadoHojaDeRuta estado
	
 	@JsonView(View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@OneToMany(mappedBy="hojaDeRuta", fetch=FetchType.LAZY)
	Set<Remito> remitos = newHashSet
	
	new() { }
	
	def void setRemitos(Set<Remito> _remitos) {
		_remitos.forEach[remito | 
			remito.hojaDeRuta = this
		]
		remitos = _remitos
	}
	
}