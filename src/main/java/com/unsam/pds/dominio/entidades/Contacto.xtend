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
import javax.persistence.OneToMany
import java.util.Set
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.FetchType
import javax.persistence.CascadeType
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name="contacto")
class Contacto {
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_contacto
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Perfil, View.HojaDeRuta.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Perfil)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String apellido
	
	/**
	 * Un cliente tiene muchos contactos
	 *  un contacto pertenece a un cliente
	 */
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_cliente", nullable=false)
	@JsonIgnore
	Cliente cliente
	
	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Perfil)
	@OneToMany(mappedBy="contacto", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Set<Email> emails = newHashSet

	@JsonView(View.Cliente.Perfil, View.Cliente.Lista, View.Cliente.Post, View.Remito.Perfil, View.HojaDeRuta.Perfil)
	@OneToMany(mappedBy="contacto", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	Set<Telefono> telefonos = newHashSet
	
	new() { }
	
	def void setTelefonos(Set<Telefono> _telefonos) {
		_telefonos.forEach[ telefono |
			telefono.contacto = this
		]
		telefonos = _telefonos
	}
	
	def void setEmails(Set<Email> _emails) {
		_emails.forEach[ email |
			email.contacto = this
		]
		emails = _emails
	}
	
	def void setCliente(Cliente _cliente) {
		_cliente.agregarContacto(this)
		cliente = _cliente
	}
	
	def void agregarTelefono(Telefono telefono) {
		telefonos.add(telefono)
	}
	
	def void agregarEmail(Email email) {
		emails.add(email)
	}
}