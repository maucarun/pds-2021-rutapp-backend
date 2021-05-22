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
import com.unsam.pds.servicio.ServicioContacto
import com.unsam.pds.dominio.entidades.Contacto
import com.unsam.pds.servicio.ServicioTelefono
import com.unsam.pds.dominio.entidades.Telefono
import com.unsam.pds.servicio.ServicioEmail
import com.unsam.pds.dominio.entidades.Email
import com.unsam.pds.servicio.ServicioEstado
import com.unsam.pds.dominio.entidades.EstadoHojaDeRuta
import com.unsam.pds.dominio.entidades.EstadoRemito
import com.unsam.pds.servicio.ServicioHojaDeRuta
import com.unsam.pds.dominio.entidades.HojaDeRuta
import java.time.LocalDateTime
import java.time.LocalDate
import com.unsam.pds.dominio.entidades.Remito
import com.unsam.pds.servicio.ServicioRemito
import com.unsam.pds.servicio.ServicioProductoRemito
import com.unsam.pds.dominio.entidades.ProductoRemito

@Service
class Bootstrap implements InitializingBean {
	
	@Autowired ServicioCliente 			servicioClientes
	@Autowired ServicioContacto 		servicioContactos
	@Autowired ServicioDiaSemana 		servicioDiasSemana
	@Autowired ServicioDireccion 		servicioDirecciones
	@Autowired ServicioDisponibilidad 	servicioDisponibilidad
	@Autowired ServicioEmail 			servicioEmails
	@Autowired ServicioEstado 			servicioEstados
	@Autowired ServicioHojaDeRuta		servicioHojaDeRuta
	@Autowired ServicioProducto 		servicioProductos
	@Autowired ServicioProductoRemito 	servicioProductoRemitos
	@Autowired ServicioRemito			servicioRemitos
	@Autowired ServicioTelefono 		servicioTelefonos
	@Autowired ServicioUsuario 			servicioUsuarios
	
	/** Crear dias */
	DiaSemana lunes = new DiaSemana() => [ dia_semana = "Lunes" ]
	DiaSemana martes = new DiaSemana() => [ dia_semana = "Martes" ]
	DiaSemana miercoles = new DiaSemana() => [ dia_semana = "Miercoles" ]
	DiaSemana jueves = new DiaSemana() => [ dia_semana = "Jueves" ]
	DiaSemana viernes = new DiaSemana() => [ dia_semana = "Viernes" ]
	DiaSemana sabado = new DiaSemana() => [ dia_semana = "Sabado" ]
	DiaSemana domingo = new DiaSemana() => [ dia_semana = "Domingo" ]
	
	/** Crear direcciones */
	Direccion direccionMoe = new Direccion() => [
		calle = "25 de Mayo"
		altura = 100
		localidad = "San Martin"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]

	/** Crear fechas */
	LocalDate fechaDeHoy = LocalDate.now 
	LocalDate fechaDeManana = LocalDate.now.plusDays(1)
	
	/** Crear horas de apertura y cierre */
	LocalTime AM08 = LocalTime.of(8,0)
	LocalTime AM12 = LocalTime.of(12,0)
	
	/** Crear tiempos */
	LocalTime diezMinutos = LocalTime.of(0,10)
	
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
	
	/*
	 * NOTA: Los objetos creados ABAJO DEPENDEN de los objetos creados ARRIBA
	 */

	/** Crear fecha con horas */
	LocalDateTime fechaDeHoyAM08 = LocalDateTime.of(fechaDeHoy, AM08)
	LocalDateTime fechaDeHoyAM12 = LocalDateTime.of(fechaDeHoy, AM12)
	LocalDateTime fechaDeMananaAM08 = LocalDateTime.of(fechaDeManana, AM08)
	LocalDateTime fechaDeMananaAM12 = LocalDateTime.of(fechaDeManana, AM12)
	
	/** Crear productos */
	Producto ventiladorHomero = new Producto() => [
		nombre = "ventilador"
		precio_unitario = 1000.0
		descripcion = "es un ventilador"
		url_imagen = ""
		propietario = homero
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
	Disponibilidad disponibilidadMoeLunes = new Disponibilidad(barMoe, lunes, AM08, AM12)
	
	/** Crear contacto */
	Contacto moe = new Contacto() => [ 
		nombre = "Moe"
		apellido = "Syzlack"
		cliente = barMoe
	]
	
	/** Crear telefonos */
	Telefono telefonoMoe = new Telefono() => [
		telefono = "1122223333"
		esPrincipal = true
		contacto = moe
	]
	
	/** Crear emails */
	Email emailMoe = new Email() => [
		direccion = "moe@mail.com"
		esPrincipal = true
		contacto = moe
	]
	
	/** Crear estados */
	EstadoHojaDeRuta estadoHdrSuspendida = new EstadoHojaDeRuta() => [ nombre = "Suspendida" ]
	EstadoHojaDeRuta estadoHdrPendiente = new EstadoHojaDeRuta() => [ nombre = "Pendiente" ]
	EstadoRemito estadoRemitoCancelado = new EstadoRemito() => [ nombre = "Cancelado" ]
	EstadoRemito estadoRemitoPendiente = new EstadoRemito() => [ nombre = "Pendiente" ]
	
	/** Crear hoja de rutas */
	HojaDeRuta hojaDeRutaHoy = new HojaDeRuta() => [
		fecha_hora_inicio = fechaDeHoyAM08
		fecha_hora_fin = fechaDeHoyAM12
		kms_recorridos = 0.0
		justificacion = ""
		estado = estadoHdrSuspendida
	]
	
	HojaDeRuta hojaDeRutaManana = new HojaDeRuta() => [
		fecha_hora_inicio = fechaDeMananaAM08
		fecha_hora_fin = fechaDeMananaAM12
		kms_recorridos = 0.0
		justificacion = ""
		estado = estadoHdrPendiente
	]
	
	/** Crear remitos */
	Remito remitoMoe = new Remito() => [
		fecha = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = barMoe
		estado = estadoRemitoPendiente
		hojaDeRuta = hojaDeRutaHoy
	]
	
	/** Crear PRs */
	ProductoRemito productoRemitoMoe = new ProductoRemito(remitoMoe, ventiladorHomero, 10, ventiladorHomero.precio_unitario, 1.0)
	
	/**
	 * Es importante el orden en que se guardan los objetos
	 */
	def void init_app() {
		/** Guardando usuarios */
		servicioUsuarios.crearNuevoUsuario(homero)
		servicioUsuarios.crearNuevoUsuario(bart)
		/** Guardando dias */
		servicioDiasSemana.crearNuevoDia(lunes)
		servicioDiasSemana.crearNuevoDia(martes)
		servicioDiasSemana.crearNuevoDia(miercoles)
		servicioDiasSemana.crearNuevoDia(jueves)
		servicioDiasSemana.crearNuevoDia(viernes)
		servicioDiasSemana.crearNuevoDia(sabado)
		servicioDiasSemana.crearNuevoDia(domingo)
		/** Guardando productos */
		servicioProductos.crearNuevoProducto(ventiladorHomero)
		/** Guardando direcciones */
		servicioDirecciones.crearNuevaDireccion(direccionMoe)
		/** Guardando clientes */
		servicioClientes.crearNuevoCliente(barMoe)
		/** Guardando disponibilidad */
		servicioDisponibilidad.crearNuevaDisponibilidad(disponibilidadMoeLunes)
		/** Guardando contactos */
		servicioContactos.crearNuevoContacto(moe)
		/** Guardando telefonos */
		servicioTelefonos.crearNuevoTelefono(telefonoMoe)
		/** Guardando emails */
		servicioEmails.crearNuevoEmail(emailMoe)
		/** Guardando estados */
		servicioEstados.crearNuevoEstado(estadoHdrSuspendida)
		servicioEstados.crearNuevoEstado(estadoHdrPendiente)
		servicioEstados.crearNuevoEstado(estadoRemitoCancelado)
		servicioEstados.crearNuevoEstado(estadoRemitoPendiente)
		/** Guardando hoja de rutas */
		servicioHojaDeRuta.crearNuevaHdr(hojaDeRutaHoy)
		servicioHojaDeRuta.crearNuevaHdr(hojaDeRutaManana)
		/** Guardando remitos */
		servicioRemitos.crearNuevoRemito(remitoMoe)
		/** Guardar PRs */
		servicioProductoRemitos.crearNuevoProductoRemito(productoRemitoMoe)
		/**
		 * Si agregamos un producto al remito lanza nullPointerException
		remitoMoe.agregarProducto(productoRemitoMoe)
		 */
	}

	override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Running initialization")
		println("************************************************************************")
		init_app
	}
	
}