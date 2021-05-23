package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioUsuario
import com.unsam.pds.dominio.entidades.Usuario
import javassist.NotFoundException
import javax.transaction.Transactional

@Service
class ServicioUsuario {
	
	@Autowired RepositorioUsuario repositorioUsuarios
	
	@Transactional
	def void crearNuevoUsuario(Usuario nuevoUsuario) {
		repositorioUsuarios.save(nuevoUsuario)
	}
	
	def Usuario obtenerUsuarioPorId(Long idUsuario) {
		repositorioUsuarios.findById(idUsuario).orElseThrow([
			throw new NotFoundException("No existe el usuario con el id " + idUsuario)
		])
	}
}