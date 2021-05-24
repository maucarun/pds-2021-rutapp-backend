package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.RepositorioTelefono
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.dominio.entidades.Telefono
import javax.transaction.Transactional
import java.util.Set

@Service
class ServicioTelefono {
	
	@Autowired RepositorioTelefono repositorioTelefonos
	
	@Transactional
	def void crearNuevoTelefono(Telefono nuevoTelefono) {
		repositorioTelefonos.save(nuevoTelefono)
	}
	
	@Transactional
	def void crearNuevosTelefonos(Set<Telefono> telefonos) {
		repositorioTelefonos.saveAll(telefonos)		
	}
	
}