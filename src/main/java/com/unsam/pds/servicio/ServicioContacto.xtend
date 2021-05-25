package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioContacto
import com.unsam.pds.dominio.entidades.Contacto
import javax.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import javassist.NotFoundException

@Service
class ServicioContacto {
	
	Logger logger = LoggerFactory.getLogger(ServicioContacto)
	
	@Autowired RepositorioContacto repositorioContactos
	
	def Contacto obtenerContactoPorId(Long idContacto) {
		repositorioContactos.findById(idContacto).orElseThrow([
			throw new NotFoundException("No existe el contacto con el id " + idContacto)
		])
	}
	
	@Transactional
	def void eliminarContactosPorCliente(Long idCliente) {
		repositorioContactos.deleteByCliente_idCliente(idCliente)
	}
	
	@Transactional
	def void crearNuevoContacto (Contacto nuevoContacto) {
		logger.info("Creando el contacto " + nuevoContacto.nombre.concat(" " + nuevoContacto.apellido))
		repositorioContactos.save(nuevoContacto)
		logger.info("Contacto creado exitosamente!")
	}
	
}