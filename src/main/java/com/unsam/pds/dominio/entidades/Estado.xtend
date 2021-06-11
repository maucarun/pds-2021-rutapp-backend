package com.unsam.pds.dominio.entidades

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
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "tipo", visible = true) 
@JsonSubTypes(#[
	@JsonSubTypes.Type(value = EstadoRemito, name = "Remito"), 
	@JsonSubTypes.Type(value = EstadoHojaDeRuta, name= "HojaDeRuta")
])
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@Entity(name="estado")
@Accessors
abstract class Estado {
	
	@JsonView(View.Remito.Perfil, View.Remito.Perfil)
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
	Long id_estado
	
	@NotNull
	@JsonView(View.Remito.Perfil, View.Remito.Perfil)
	@Column(length=20, nullable=false, unique=false)
	String nombre
	
	new() { }
	
}

@Accessors
@Entity(name="estado_remito")
class EstadoRemito extends Estado {

	new() { }

}

@Accessors
@Entity(name="estado_hoja_ruta")
class EstadoHojaDeRuta extends Estado {

	new() { }
	
}