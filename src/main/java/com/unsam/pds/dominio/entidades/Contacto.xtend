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
	@JoinColumn(name="id_cliente", nullable=false)
	@JsonIgnore
	Cliente cliente
	
	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	@JoinColumn(name="id_email")
	Set<Email> emails = newHashSet

	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	@JoinColumn(name="id_telefono")
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
}