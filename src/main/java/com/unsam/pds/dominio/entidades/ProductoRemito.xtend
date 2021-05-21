package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Column
import javax.persistence.ManyToOne
import javax.persistence.JoinColumn
import javax.persistence.EmbeddedId
import javax.persistence.MapsId
import com.unsam.pds.dominio.keys.ProductoRemitoKey

@Accessors
@Entity(name="producto_remito")
class ProductoRemito {
	
	@EmbeddedId
	ProductoRemitoKey id_producto_remito;
	
	@ManyToOne
	@MapsId("idRemito")
	@JoinColumn(name="id_remito")
	Remito remito
	
	@ManyToOne
	@MapsId("idProducto")
	@JoinColumn(name="id_producto")
	Producto producto
	
	@Column(nullable=false, unique=false)
	Integer cantidad
	
	@Column(nullable=false, unique=false, name="precio_unitario")
	Double precio_unitario
	
	@Column(nullable=false, unique=false)
	Double descuento

}