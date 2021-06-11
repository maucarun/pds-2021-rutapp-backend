package com.unsam.pds.dominio.Generics

import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PaginationResponse<T> {
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	Long cant;
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	Long paganro;
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	Long cantporpag;
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	Long offset;
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	Long cantpag;
	@JsonView(
		View.Cliente.Perfil,
		View.Cliente.Lista,
		View.Producto.Perfil,
		View.Producto.Lista,
		View.Remito.Perfil,
		View.Remito.Lista
	)
	List<T> reultado;

	new(Long cant, Long paganro, Long cantporpag, Long offset, Long cantpag, List<T> reultado) {
		this.cant = cant
		this.paganro = paganro
		this.cantporpag = cantporpag
		this.offset = offset
		this.cantpag = cantpag
		this.reultado = reultado
	}

	def List<T> get() { reultado }
}
