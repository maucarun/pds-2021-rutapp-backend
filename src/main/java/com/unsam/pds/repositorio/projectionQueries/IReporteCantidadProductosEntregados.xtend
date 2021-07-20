package com.unsam.pds.repositorio.projectionQueries

interface IReporteCantidadProductosEntregados {
	
	def Long getIdProducto()
	
	def String getNombreProducto()
	
	def Long getCantidad()
	
	def String getNombreCliente()

}