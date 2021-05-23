package com.unsam.pds.repositorio

import com.unsam.pds.dominio.entidades.ComprobanteEntrega
import org.springframework.data.repository.CrudRepository

interface RepositorioComprobanteEntrega extends CrudRepository <ComprobanteEntrega, Long> {
	
}