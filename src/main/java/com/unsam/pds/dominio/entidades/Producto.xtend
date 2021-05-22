package com.unsam.pds.dominio.entidades

import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors
import javax.validation.constraints.Positive
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Accessors
@Entity(name="producto")
class Producto {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_producto
	
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@Positive(message="El precio debe ser positivo")
	@Column(nullable=false, unique=false, name="precio_unitario")
	Double precio_unitario
	
	@Column(length=250, nullable=true, unique=false)
	String descripcion
	
	/**
	 * TODO: vamos a tener las imagenes en un servidor local?
	 */
	@Column(length=100, nullable=true, unique=false)
	String url_imagen
	
	@NotNull
	@Column(nullable=false, unique=false)
	Boolean activo = true
	
	/**
	 * Un usuario puede tener muchos productos
	 *  El producto pertenece a un usuario
	 */
	@ManyToOne
	@JoinColumn(name="id_usuario")
	Usuario propietario
	
	new() { }
	
	def void eliminarProducto() {
		activo = false
	}
	
}