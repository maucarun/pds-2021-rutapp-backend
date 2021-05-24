package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Cliente
import java.util.List
import com.unsam.pds.dominio.entidades.Usuario

interface RepositorioCliente extends CrudRepository <Cliente, Long> {
	
	def List<Cliente> findByPropietario(Usuario usuario)
	
}