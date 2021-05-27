package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Usuario
import java.util.Optional

interface RepositorioUsuario extends CrudRepository<Usuario, Long> {

	def Boolean existsByUsernameAndPasswordAndActivo(String username, String password, Boolean activo)
	
	def Optional<Usuario> findByUsername(String username)

}
