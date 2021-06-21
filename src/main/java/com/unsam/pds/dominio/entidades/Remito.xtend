package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Column
import java.time.LocalDate
import javax.validation.constraints.PositiveOrZero
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import java.util.Set
import javax.persistence.OneToMany
import java.time.LocalTime
import com.fasterxml.jackson.annotation.JsonIgnore
import javax.persistence.FetchType
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import javax.persistence.OneToOne
import javax.persistence.CascadeType

@Accessors
@Entity(name="remito")
class Remito {
	
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.HojaDeRuta.Perfil, View.HojaDeRuta.Post)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long idRemito
	
	@Column(nullable=false, unique=false)
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.Remito.Post)
	LocalDate fechaDeCreacion
	
	@JsonView(View.Remito.Lista, View.Remito.Perfil)
	@PositiveOrZero(message="El total no puede ser negativo")
	@Column(nullable=false, unique=false)
	Double total = 0.0
	
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.Remito.Post)
	@Column(length=250, nullable=true, unique=false)
	String motivo
	
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.Remito.Post)
	@PositiveOrZero(message="El tiempo no puede ser negativo")
	@Column(nullable=false, unique=false)
	Integer tiempo_espera = 0
	
	/**
	 * Un cliente puede tener muchos remitos
	 *  Un remito pertenece a un solo cliente
	 */
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.Remito.Post, View.HojaDeRuta.Perfil)
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_cliente")
	Cliente cliente
	
	/**
	 * Un estado puede estar en muchos remitos
	 *  Un remito tiene un solo estado
	 */
	@ManyToOne(fetch=FetchType.LAZY)
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.HojaDeRuta.Perfil)
	@JoinColumn(name="id_estado")
	EstadoRemito estado
	
	/**
	 * Un remito pertenece a una hdr
	 *  una hdr puede tener muchos remitos
	 */
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_hoja_de_ruta")
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.Remito.Post)
	HojaDeRuta hojaDeRuta
	
	@JsonView(View.Remito.Perfil, View.Remito.Post)
	@OneToMany(mappedBy = "remito", fetch=FetchType.LAZY)
	Set<ProductoRemito> productosDelRemito = newHashSet
	
	@JsonView(View.Remito.Perfil, View.Remito.Post)
	@OneToOne(mappedBy = "remito", fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	ComprobanteEntrega comprobante
	
	new () { }
	
	def void calcularTotal() {
		/** Alternativa
		 productosDelRemito.forEach[ producto | total = total + producto.calcularSubCosto() ]
		 */
		
		/** En un fold va primero el total a devolver y luego el elemento de la lista */
		total = productosDelRemito.fold(0.0)[subTotal, producto | subTotal + producto.calcularSubCosto()]
		
	}
	
	def void agregarProducto(ProductoRemito nuevoProducto) {
		productosDelRemito.add(nuevoProducto)
		calcularTotal()
	}
	
//	def void setProductos(Set<ProductoRemito> _productos) {
//		_productos.forEach[producto | 
//			producto.remito = this
//		]
//		
//		productos = _productos
//		calcularTotal()
//	}
	
	def void setComprobante(ComprobanteEntrega _comprobante) {
		comprobante = _comprobante
		_comprobante.remito = this
	}
	
	@JsonView(View.Remito.Lista, View.Remito.Perfil, View.HojaDeRuta.Perfil)
	def Integer cantidadDeItems() {
		productosDelRemito.size
	}
	
	@JsonView(View.Remito.Lista)
	def LocalDate fechaEntregado() {
		if (comprobante !== null)
			comprobante.fechaHoraEntrega.toLocalDate
	}
	
}