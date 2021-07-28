package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioUsuario
import com.unsam.pds.dominio.entidades.Usuario
import javassist.NotFoundException
import javax.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.unsam.pds.dominio.Exceptions.UnauthorizedException

@Service
class ServicioUsuario {

	Logger logger = LoggerFactory.getLogger(ServicioUsuario)

	@Autowired RepositorioUsuario repo

	def Usuario validarUsuario(String username, String password) {
		if (!repo.existsByUsernameAndPasswordAndActivo(username, password, true)) 
			throw new NotFoundException("Usuario y/o contraseña no son validos")
		obtenerUsuarioPorUsername(username)
	}
	
	def Usuario obtenerUsuarioPorUsername(String username) {
		repo.findByUsername(username).orElseThrow([
			throw new NotFoundException("No existe el usuario con el username " + username)
		])
	}

	def Usuario obtenerUsuarioPorId(Long idUsuario) {
		repo.findById(idUsuario).orElseThrow([
			throw new NotFoundException("No existe el usuario con el id " + idUsuario)
		])
	}

	@Transactional
	def void crearNuevoUsuario(Usuario nuevoUsuario) {
		repo.save(nuevoUsuario)
	}

	@Transactional
	def void actualizarUsuario(Long idUsuario, Usuario usuarioModificado) {
		obtenerUsuarioPorId(idUsuario)
		crearNuevoUsuario(usuarioModificado)
		logger.info("Usuario actualizado exitosamente!")
	}
	
	def void desactivarUsuario(Long idUsuario) {
		var usuario = obtenerUsuarioPorId(idUsuario)
		usuario.desactivarUsuario
		logger.info("Usuario desactivado exitosamente!")
	}

	def Long validar(String username, String password) {
		var usr = repo.findByUsernameAndPasswordAndActivo(username, password, true)
		if(!usr.present)
			throw new UnauthorizedException("Credenciales de autenticación invalidas")
			
		usr.get.idUsuario
	}
	
	def Usuario validarEmail(String email){
		repo.findByEmail(email).orElseThrow([
			throw new NotFoundException("No existe un usuario con el email asociado " + email)
		])
	}
}
