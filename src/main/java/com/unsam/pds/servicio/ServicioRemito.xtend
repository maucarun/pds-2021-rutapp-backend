package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioRemito
import com.unsam.pds.dominio.entidades.Remito
import javax.transaction.Transactional
import javassist.NotFoundException
import org.springframework.beans.BeanUtils
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.List

@Service
class ServicioRemito {
	
	Logger logger = LoggerFactory.getLogger(ServicioRemito)

	@Autowired RepositorioRemito repositorioRemitos
	@Autowired ServicioProductoRemito servicioProductoRemito

	def Remito obtenerRemitoPorId(Long idRemito) {
		repositorioRemitos.findById(idRemito).orElseThrow([
			throw new NotFoundException("No existe el remito con el id " + idRemito)
		])
	}
	
	def List<Remito> obtenerRemitosPorIdUsuario(Long idUsuario) {
		repositorioRemitos.findRemitosByIdUsuario(idUsuario)
	}
	
	def List<Remito> obtenerRemitosPendientesPorIdCliente(Long idCliente) {
		repositorioRemitos.findByCliente_idClienteAndEstado_nombre(idCliente, "Pendiente")
	}
	
	def void actualizarOCrearRemito( Remito remito){
		repositorioRemitos.save(remito)
		servicioProductoRemito.guardarProductoRemito(remito.productos)
	}
//	@Transactional
//	def void actualizarRemito(Long idRemito, Remito nuevoRemito) {
//		var remitoAModificar = obtenerRemitoPorId(idRemito)
//		logger.info("Actualizando el remito del " + remitoAModificar.fechaDeCreacion + " para el cliente " +
//			remitoAModificar.cliente.nombre)
//		BeanUtils.copyProperties(nuevoRemito, remitoAModificar)
//		crearNuevoRemito(remitoAModificar)
//		logger.info("Remito actualizado!")
//	}
}
