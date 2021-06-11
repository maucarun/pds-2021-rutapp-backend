package com.unsam.pds.dominio.entidades

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import javax.validation.constraints.Size
import javax.persistence.OneToOne
import javax.persistence.JoinColumn
import java.time.LocalDateTime
import javax.persistence.FetchType
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@Accessors
@Entity(name="comprobante_entrega")
class ComprobanteEntrega {
	@JsonView(View.Remito.Perfil, View.Remito.Perfil, View.Remito.Post)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_comprobante
	
	@NotNull
	@JsonView(View.Remito.Perfil, View.Remito.Perfil, View.Remito.Post)
	@Column(length=150, nullable=false, unique=false)
	String nombre_completo
	
	@Size(min=7, max=9)
	@JsonView(View.Remito.Perfil, View.Remito.Perfil, View.Remito.Post)
	@Column(length=10, nullable=false, unique=false)
	String dni
	
	@NotNull
	@JsonView(View.Remito.Perfil, View.Remito.Perfil, View.Remito.Post)
	@Column(nullable=false, unique=false)
	LocalDateTime fechaHoraEntrega
	
	@OneToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="id_remito", nullable = false, unique = true)
	Remito remito
	
	new() { }
	
	def void setRemito(Remito _remito) {
		if (_remito.hojaDeRuta === null )
			throw new RuntimeException("La hoja de ruta del remito no puede ser nula")
		remito = _remito
	}
}