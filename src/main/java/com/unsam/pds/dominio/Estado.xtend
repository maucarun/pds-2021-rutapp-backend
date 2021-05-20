package com.unsam.pds.dominio

import org.eclipse.xtend.lib.annotations.Accessors
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.validation.constraints.NotNull
import javax.persistence.Column
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonSubTypes
import javax.persistence.InheritanceType
import javax.persistence.Inheritance

@Accessors
@Entity(name="estado")
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "tipo", visible = true) 
@JsonSubTypes(#[
	@JsonSubTypes.Type(value = EstadoRemito, name = "Remito"), 
	@JsonSubTypes.Type(value = EstadoHojaDeRuta, name= "HojaDeRuta")
])
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
abstract class Estado {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_estado
	
	@NotNull
	@Column(length=20, nullable=false, unique=false)
	String nombre
}

@Accessors
@Entity(name="estado_remito")
class EstadoRemito extends Estado {
	
}

@Accessors
@Entity(name="estado_hoja_ruta")
class EstadoHojaDeRuta extends Estado {
	
}