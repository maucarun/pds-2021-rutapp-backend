package com.unsam.pds.dominio

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column

@Accessors
@Entity(name="dia_semana")
class DiaSemana {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_dia_semana
	
	@NotNull
	@Column(length=15, nullable=false, unique=true)
	String dia_semana
}