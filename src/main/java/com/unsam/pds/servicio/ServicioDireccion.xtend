package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioDireccion
import com.unsam.pds.dominio.entidades.Direccion
import javax.transaction.Transactional
import org.springframework.beans.BeanUtils
import javassist.NotFoundException

@Service
class ServicioDireccion {
	
	@Autowired RepositorioDireccion repositorioDirecciones
	
	def Direccion obtenerDireccionPorId(Long idDireccion) {
		repositorioDirecciones.findById(idDireccion).orElseThrow([
			throw new NotFoundException("No existe la direccion con el id " + idDireccion)
		])
	}
	
	@Transactional
	def void crearNuevaDireccion(Direccion nuevaDireccion) {
		repositorioDirecciones.save(nuevaDireccion)
	}
	
	@Transactional
	def void actualizarDireccion(Direccion direccionModificada) {
		var direccionAModificar = obtenerDireccionPorId(direccionModificada.id_direccion)
		BeanUtils.copyProperties(direccionModificada, direccionAModificar)
		crearNuevaDireccion(direccionAModificar)
	}
	
}