package com.unsam.pds.dominio.keys

import javax.persistence.Embeddable
import org.eclipse.xtend.lib.annotations.Accessors
import java.io.Serializable
import javax.persistence.Column

@Embeddable
@Accessors
class DisponibilidadKey implements Serializable {
	
	@Column(name = "id_cliente")
	Long idCliente
	
	@Column(name = "id_dia_semana")
	Long idDiaSemana

}