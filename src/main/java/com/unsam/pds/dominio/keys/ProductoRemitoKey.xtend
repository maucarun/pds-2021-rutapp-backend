package com.unsam.pds.dominio.keys

import javax.persistence.Embeddable
import java.io.Serializable
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Embeddable
@Accessors
class ProductoRemitoKey implements Serializable{
	@JsonView(View.Remito.Perfil)
	@Column(name = "id_producto")
	Long idProducto
	@JsonView(View.Remito.Perfil)
	@Column(name = "id_remito")
	Long idRemito

	/**
	 * Es importante crear el constructor para definir los ids
	 *  y el constructor por defecto
	 */
	new() { }
	
	new (Long _idProducto, Long _idRemito) {
		idProducto = _idProducto
		idRemito = _idRemito
	}
	
}