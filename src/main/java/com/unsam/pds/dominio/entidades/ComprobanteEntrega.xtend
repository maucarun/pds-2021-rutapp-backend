package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import javax.validation.constraints.Size
import java.time.LocalTime
import javax.persistence.OneToOne
import javax.persistence.JoinColumn

@Accessors
@Entity(name="comprobante_entrega")
class ComprobanteEntrega {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_comprobante
	
	@NotNull
	@Column(length=150, nullable=false, unique=false)
	String nombre_completo
	
	@Size(min=7, max=9)
	@Column(length=10, nullable=false, unique=false)
	String dni
	
	@NotNull
	@Column(nullable=false, unique=false, name="hora_entrega")
	LocalTime hora_entrega
	
	@OneToOne
	@JoinColumn(name="id_remito", nullable = false, unique = true)
	Remito remito
	
	new() { }
	
	def void setRemito(Remito _remito) {
		if (_remito.hojaDeRuta === null )
			throw new RuntimeException("La hoja de ruta del remito no puede ser nula")
		remito = _remito
	}
}