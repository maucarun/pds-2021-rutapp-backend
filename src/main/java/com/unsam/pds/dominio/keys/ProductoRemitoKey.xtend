package com.unsam.pds.dominio.keys

import javax.persistence.Embeddable
import java.io.Serializable
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors

@Embeddable
@Accessors
class ProductoRemitoKey implements Serializable{
	
	@Column(name = "id_producto")
	Long idProducto
	
	@Column(name = "id_remito")
	Long idRemito

}