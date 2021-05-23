package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioComprobanteEntrega
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.ComprobanteEntrega

@Service
class ServicioComprobanteEntrega {
	
	@Autowired RepositorioComprobanteEntrega repositorioComprobantes
	
	@Transactional
	def void crearNuevoComprobante(ComprobanteEntrega nuevoComprobante) {
		repositorioComprobantes.save(nuevoComprobante)
	}
	
}