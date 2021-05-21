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
import javax.validation.constraints.PositiveOrZero

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
	
	@PositiveOrZero(message="El total no puede ser negativo")
	@Column(nullable=false, unique=false)
	Double total
	
	@Column(length=250, nullable=true, unique=false)
	String motivo
	
	@PositiveOrZero(message="La hora de entrega no puede ser negativa")
	@Column(nullable=false, unique=false, name="hora_entrega")
	LocalTime hora_entrega
	
}