package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import javax.validation.constraints.Positive
import javax.persistence.CascadeType
import javax.persistence.JoinColumn
import javax.persistence.OneToOne
import javax.validation.constraints.Size
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import java.util.Set
import javax.persistence.FetchType
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name="cliente")
class Cliente {
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Put, View.Remito.Perfil, View.Remito.Post)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long idCliente
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Lista, View.Remito.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@Column(length=250, nullable=true, unique=false)
	String observaciones
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@Size(min=10, max=12)
	@Column(length=13, nullable=false, unique=false)
	String cuit
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@Column(length=250, nullable=true, unique=false)
	String urlImagenPerfil
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@Positive(message="El promedio de espera debe ser positivo")
	@Column(nullable=false, unique=false, name="promedio_espera")
	Double promedio_espera
	
	@Column(nullable=false, unique=false)
	Boolean activo = true
	
	/**
	 * Un usuario puede tener muchos clientes
	 *  El cliente pertenece a un usuario
	 */
	@JsonView(View.Cliente.Perfil)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="id_usuario")
	Usuario propietario
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post)
	@OneToOne(cascade=CascadeType.ALL, fetch=FetchType.LAZY)
	@JoinColumn(name="id_direccion", nullable=false)
	Direccion direccion
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@OneToMany(mappedBy = "cliente", fetch=FetchType.LAZY)
	Set<Disponibilidad> disponibilidades = newHashSet
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Post)
	@OneToMany(mappedBy="cliente", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Set<Contacto> contactos = newHashSet
	
	new () { }
	
	def void agregarDisponibilidad(Disponibilidad nuevaDisponibilidad) {
		disponibilidades.add(nuevaDisponibilidad)
	}
	
	def void agregarContacto(Contacto nuevoContacto) {
		contactos.add(nuevoContacto)
	}
	
	def void setContactos(Set<Contacto> _contactos){
		_contactos.forEach[contacto |
			contacto.cliente = this
		]
		contactos = _contactos
	}
	
	def void setDireccion(Direccion _direccion) {
		direccion = _direccion
		_direccion.cliente = this
	}
	
	def void desactivarCliente() {
		activo = false
	}
	
}