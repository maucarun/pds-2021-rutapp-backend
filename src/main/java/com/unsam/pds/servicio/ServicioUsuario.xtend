package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioUsuario
import com.unsam.pds.dominio.entidades.Usuario

@Service
class ServicioUsuario {
	
	@Autowired RepositorioUsuario repositorioUsuarios
	
	def void crearNuevoUsuario(Usuario nuevoUsuario) {
		repositorioUsuarios.save(nuevoUsuario)
	}
}