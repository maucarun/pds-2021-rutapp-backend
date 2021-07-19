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
import javax.persistence.FetchType
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name="producto")
class Producto {
	
	@JsonView(View.Producto.Perfil, View.Producto.Lista, View.Producto.Put, View.Remito.Perfil, View.Remito.ProductoVentas)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long idProducto

	@JsonView(View.Producto.Perfil, View.Producto.Lista, View.Producto.Post, View.Remito.Perfil, View.Remito.ProductoVentas)
	@NotNull
	@Column(length=50, nullable=false, unique=false)
	String nombre
	
	@JsonView(View.Producto.Perfil, View.Producto.Lista, View.Producto.Post, View.Remito.Perfil)
	@Positive(message="El precio debe ser positivo")
	@Column(nullable=false, unique=false, name="precio_unitario")
	Double precio_unitario
	
	@JsonView(View.Producto.Perfil, View.Producto.Lista, View.Producto.Post)
	@Column(length=250, nullable=true, unique=false)
	String descripcion
	
	/**
	 * TODO: vamos a tener las imagenes en un servidor local?
	 */
 	@JsonView(View.Producto.Perfil, View.Producto.Lista, View.Producto.Post)
	@Column(length=250, nullable=true, unique=false)
	String url_imagen
	
	@NotNull
	@Column(nullable=false, unique=false)
	@JsonView(View.Producto.Perfil, View.Producto.Lista)
	Boolean activo = true
	
	/**
	 * Un usuario puede tener muchos productos
	 *  El producto pertenece a un usuario
	 */
 	@JsonView(View.Producto.Lista)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="id_usuario")
	Usuario propietario
	
	new() { }
	
	def void desactivarProducto() {
		activo = false
	}
	
}