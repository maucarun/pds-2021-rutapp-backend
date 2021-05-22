package com.unsam.pds.dominio

import org.springframework.beans.factory.InitializingBean
import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.servicio.ServicioUsuario
import com.unsam.pds.dominio.entidades.Usuario
import com.unsam.pds.dominio.entidades.DiaSemana
import com.unsam.pds.servicio.ServicioDiaSemana
import com.unsam.pds.dominio.entidades.Producto
import com.unsam.pds.servicio.ServicioProducto
import com.unsam.pds.dominio.entidades.Direccion
import com.unsam.pds.servicio.ServicioDireccion
import com.unsam.pds.servicio.ServicioCliente
import com.unsam.pds.dominio.entidades.Cliente
import com.unsam.pds.servicio.ServicioDisponibilidad
import com.unsam.pds.dominio.entidades.Disponibilidad
import java.time.LocalTime

@Service
class Bootstrap implements InitializingBean {
	
	@Autowired ServicioCliente servicioClientes
	@Autowired ServicioDiaSemana servicioDiasSemana
	@Autowired ServicioDireccion servicioDirecciones
	@Autowired ServicioDisponibilidad servicioDisponibilidad
	@Autowired ServicioProducto servicioProductos
	@Autowired ServicioUsuario servicioUsuarios
	
	/** Crear usuarios */
	Usuario homero = new Usuario() => [
		nombre = "Homero"
		apellido = "Simpson"
		username = "homer"
		password = "abcd1"
		email = "homer@mail.com"
	]
	
	Usuario bart = new Usuario() => [
		nombre = "Bartolomeo"
		apellido = "Simpson"
		username = "elBarto"
		password = "abcd1"
		email = "bartman@mail.com"
	]
	
	/** Crear dias */
	DiaSemana lunes = new DiaSemana() => [ dia_semana = "Lunes" ]
	DiaSemana martes = new DiaSemana() => [ dia_semana = "Martes" ]
	DiaSemana miercoles = new DiaSemana() => [ dia_semana = "Miercoles" ]
	DiaSemana jueves = new DiaSemana() => [ dia_semana = "Jueves" ]
	DiaSemana viernes = new DiaSemana() => [ dia_semana = "Viernes" ]
	DiaSemana sabado = new DiaSemana() => [ dia_semana = "Sabado" ]
	DiaSemana domingo = new DiaSemana() => [ dia_semana = "Domingo" ]
	
	/** Crear productos */
	Producto ventiladorHomero = new Producto() => [
		nombre = "ventilador"
		precio_unitario = 1000.0
		descripcion = "es un ventilador"
		url_imagen = ""
		propietario = homero
	]
	
	/** Crear direcciones */
	Direccion direccionMoe = new Direccion() => [
		calle = "25 de Mayo"
		altura = 100
		localidad = "San Martin"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]
	
	/** Crear clientes */
	Cliente barMoe = new Cliente() => [
		nombre = "Bar de Moe"
		observaciones = "Es un bar"
		cuit = "10301112225"
		promedio_espera = 10.0
		propietario = homero
		direccion = direccionMoe
	]
	
	/** Crear disponibilidad */
	Disponibilidad disponibilidadMoeLunes = new Disponibilidad() => [
		cliente = barMoe
		diaSemana = lunes
		hora_apertura = LocalTime.now
		hora_cierre = LocalTime.now
	]
	
	
	def void init_app() {
		servicioUsuarios.crearNuevoUsuario(homero)
		servicioUsuarios.crearNuevoUsuario(bart)
		servicioDiasSemana.crearNuevoDia(lunes)
		servicioDiasSemana.crearNuevoDia(martes)
		servicioDiasSemana.crearNuevoDia(miercoles)
		servicioDiasSemana.crearNuevoDia(jueves)
		servicioDiasSemana.crearNuevoDia(viernes)
		servicioDiasSemana.crearNuevoDia(sabado)
		servicioDiasSemana.crearNuevoDia(domingo)
		servicioProductos.crearNuevoProducto(ventiladorHomero)
		servicioDirecciones.crearNuevaDireccion(direccionMoe)
		servicioClientes.crearNuevoCliente(barMoe)
		servicioDisponibilidad.crearNuevaDisponibilidad(disponibilidadMoeLunes)
	}

	override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Running initialization")
		println("************************************************************************")
		init_app
	}
	
}