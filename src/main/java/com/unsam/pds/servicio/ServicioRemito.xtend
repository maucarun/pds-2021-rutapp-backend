package com.unsam.pds.servicio

import com.unsam.pds.dominio.Generics.GenericService
import com.unsam.pds.dominio.entidades.Remito
import com.unsam.pds.repositorio.RepositorioRemito
import java.util.List
import javassist.NotFoundException
//import org.slf4j.Logger
//import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import com.unsam.pds.dominio.entidades.Cliente
import javax.transaction.Transactional

@Service
class ServicioRemito extends GenericService<Remito, Long> {
	
	//Logger logger = LoggerFactory.getLogger(ServicioRemito)

	@Autowired RepositorioRemito repo
	@Autowired ServicioProductoRemito servicioProductoRemito
	@Autowired ServicioCliente servicioCliente

	def Remito obtenerRemitoPorId(Long idRemito) {
		repo.findById(idRemito).orElseThrow([
			throw new NotFoundException("No existe el remito con el id " + idRemito)
		])
	}
	
	def List<Remito> obtenerRemitosPorIdUsuario(Long idUsuario) {
		repo.findRemitosByIdUsuario(idUsuario)
	}
	
	def List<Remito> obtenerRemitosPendientesPorIdCliente(Long idCliente) {
		repo.findByCliente_idClienteAndEstado_nombre(idCliente, "Pendiente")
	}
	
	@Transactional
	def void actualizarOCrearRemito( Remito remito){
		repo.save(remito)
		servicioProductoRemito.guardarProductoRemito(remito)
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

	def Cliente getClienteById(Long id){
		servicioCliente.obtenerClienteActivoPorId(id)
	} 
}
