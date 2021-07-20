package com.unsam.pds.repositorio.projectionQueries

interface IReporteCantidadProductosVendidos {
	
	def Long getIdProducto()
	
	def String getNombreProducto()
	
	def Long getCantidad()
	
}