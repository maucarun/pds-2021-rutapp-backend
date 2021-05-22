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

@Accessors
@Entity(name="cliente")
class Cliente {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_cliente
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@Column(length=250, nullable=true, unique=false)
	String observaciones
	
	@Size(min=10, max=12)
	@Column(length=13, nullable=false, unique=true)
	String cuit
	
	@Positive(message="El promedio de espera debe ser positivo")
	@Column(nullable=false, unique=false, name="promedio_espera")
	Double promedio_espera
	
	@Column(nullable=false, unique=false)
	Boolean activo = true
	
	/**
	 * Un usuario puede tener muchos clientes
	 *  El cliente pertenece a un usuario
	 * 
	 * TODO: es un propietario?
	 */
	@ManyToOne
	@JoinColumn(name="id_usuario")
	Usuario propietario
	
	@OneToOne(cascade=CascadeType.REMOVE)
	@JoinColumn(name="id_direccion")
	Direccion direccion
	
	@OneToMany(mappedBy = "cliente")
	Set<Disponibilidad> disponibilidades
	
	new () { }
}