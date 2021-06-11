package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Column
import javax.persistence.ManyToOne
import javax.persistence.JoinColumn
import javax.persistence.EmbeddedId
import javax.persistence.MapsId
import com.unsam.pds.dominio.keys.ProductoRemitoKey
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import javax.persistence.FetchType
import javax.persistence.CascadeType

@Accessors
@Entity(name="producto_remito")
class ProductoRemito {
	@JsonView(View.Remito.Perfil)
	@EmbeddedId
	ProductoRemitoKey idProductoRemito;
	
	@ManyToOne
	@MapsId("idRemito")
	@JoinColumn(name="id_remito")
	@JsonIgnore
	Remito remito
	
	@JsonView(View.Remito.Perfil, View.Remito.Lista, View.Remito.Post, View.Producto.Lista)
	@ManyToOne(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	@MapsId("idProducto")
	@JoinColumn(name="id_producto")
	Producto producto
	
	@JsonView(View.Remito.Perfil, View.Remito.Lista, View.Remito.Post, View.Producto.Lista)// TODO Puede borrarse si no es necesario
	@Column(nullable=false, unique=false)
	Integer cantidad
	
	@JsonView(View.Remito.Perfil, View.Remito.Lista, View.Remito.Post, View.Producto.Lista)
	@Column(nullable=false, unique=false, name="precio_unitario")
	Double precio_unitario
	
	@JsonView(View.Remito.Perfil, View.Remito.Lista, View.Remito.Post, View.Producto.Lista)
	@Column(nullable=false, unique=false)
	Double descuento
	
	new() { }
	
	/**
	 * Es importante tener este constructor para definir el ID
	 *  ya que hibernate no puede hacer el seter id por reflection
	 */
	new(Remito _remito, Producto _producto, Integer _cantidad, Double _precioUnitario, Double _descuento) {
		idProductoRemito = new ProductoRemitoKey(_producto.idProducto, _remito.id_remito)
		remito = _remito
		producto = _producto
		cantidad = _cantidad
		precio_unitario = _precioUnitario
		descuento = _descuento
	}
	
	def Double calcularSubCosto() {
		cantidad * precio_unitario * descuento
	}
}