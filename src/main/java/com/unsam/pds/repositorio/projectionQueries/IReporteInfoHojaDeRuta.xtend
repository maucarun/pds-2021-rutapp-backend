package com.unsam.pds.repositorio.projectionQueries

interface IReporteInfoHojaDeRuta {
	def Long getIdHojaDeRuta()
	
	def String getFechaHoraInicio()
	
	def Double getKmsRecorridos()
	
	def String getEstado()
	
	def Long getCantidadClientes()
	
	def Long getCantidadClientesVisitados()
	
	def Long getCantidadProductosEntregados()
	
	def Double getPromedioEntrega()
}