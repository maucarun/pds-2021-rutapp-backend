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

@Accessors
@Entity(name="remito")
class Remito {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_remito
	
	@Column(nullable=false, unique=false)
	LocalDate fecha
	
	@PositiveOrZero(message="El total no puede ser negativo")
	@Column(nullable=false, unique=false)
	Double total = 0.0
	
	@Column(length=250, nullable=true, unique=false)
	String motivo
	
	@PositiveOrZero(message="El tiempo no puede ser negativo")
	@Column(nullable=false, unique=false)
	LocalTime tiempo_espera = LocalTime.of(0,0)
	
	/**
	 * Un cliente puede tener muchos remitos
	 *  Un remito pertenece a un solo cliente
	 */
	@ManyToOne
	@JoinColumn(name="id_cliente")
	Cliente cliente
	
	/**
	 * Un estado puede estar en muchos remitos
	 *  Un remito tiene un solo estado
	 */
	@ManyToOne
	@JoinColumn(name="id_estado")
	EstadoRemito estado
	
	/**
	 * Un remito pertenece a una hdr
	 *  una hdr puede tener muchos remitos
	 */
	@ManyToOne
	@JoinColumn(name="id_hoja_de_ruta")
	@JsonIgnore
	HojaDeRuta hojaDeRuta
	
	@OneToMany(mappedBy = "remito", fetch=FetchType.EAGER)
	Set<ProductoRemito> productos = newHashSet
	
	new () { }
	
	def void calcularTotal() {
		/** Alternativa
		 productos.forEach[ producto | total = total + producto.calcularSubCosto() ]
		 */
		
		/** En un fold va primero el total a devolver y luego el elemento de la lista */
		total = productos.fold(0.0)[subTotal, producto | subTotal + producto.calcularSubCosto()]
		
	}
	
	def void agregarProducto(ProductoRemito nuevoProducto) {
		productos.add(nuevoProducto)
		calcularTotal()
	}
	
	def void setProductos(Set<ProductoRemito> _productos) {
		_productos.forEach[producto | 
			producto.remito = this
		]
		
		productos = _productos
		calcularTotal()
	}
	
	
}