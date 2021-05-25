package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.Cliente
import java.util.List

interface RepositorioCliente extends CrudRepository <Cliente, Long> {
	
	def List<Cliente> findByPropietario_IdUsuario(Long idPropietario)
	
	def Boolean existsByIdClienteAndPropietario_IdUsuario(Long idCliente, Long idPropietario)
	
}