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
import com.unsam.pds.servicio.ServicioCliente
import com.unsam.pds.dominio.entidades.Cliente
import com.unsam.pds.dominio.entidades.Disponibilidad
import java.time.LocalTime
import com.unsam.pds.dominio.entidades.Contacto
import com.unsam.pds.dominio.entidades.Telefono
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
import com.unsam.pds.dominio.entidades.ProductoRemito
import com.unsam.pds.servicio.ServicioComprobanteEntrega
import com.unsam.pds.dominio.entidades.ComprobanteEntrega
import com.unsam.pds.repositorio.RepositorioUsuario
import java.util.Set
import com.unsam.pds.dominio.entidades.Estado

@Service
class Bootstrap implements InitializingBean {/**
	 * El bootstrap está creado con la siguiente situación:
	 * 	* Hay 2 choferes: Bart y Homero
	 *	
	 * 	* Bart y Homero comparten 2 clientes (moe y skinner), y Homero tiene uno extra (cacho)
	 * 	
	 * 	* Bart está realizando el reparto de hoy, y ya tiene programado un reparto para mañana
	 *   Mientras que Homero cancelo el reparto de hoy, y solo pudo entregar un pedido
	 * 
	 * 	* Homero vende productos de hogar, mientras que Bart ofrece servicios
	 */
	
	@Autowired ServicioCliente 			servicioClientes
	@Autowired ServicioComprobanteEntrega servicioComprobantes
	@Autowired ServicioDiaSemana 		servicioDiasSemana
	@Autowired ServicioEstado<Estado> 	servicioEstados
	@Autowired ServicioHojaDeRuta		servicioHojaDeRuta
	@Autowired ServicioProducto 		servicioProductos
	@Autowired ServicioRemito			servicioRemitos
	@Autowired ServicioUsuario 			servicioUsuarios
	@Autowired RepositorioUsuario       repositorioUsuarios
	
	/** Crear dias */
	DiaSemana lunes = new DiaSemana() => [ diaSemana = "Lunes" ]
	DiaSemana martes = new DiaSemana() => [ diaSemana = "Martes" ]
	DiaSemana miercoles = new DiaSemana() => [ diaSemana = "Miercoles" ]
	DiaSemana jueves = new DiaSemana() => [ diaSemana = "Jueves" ]
	DiaSemana viernes = new DiaSemana() => [ diaSemana = "Viernes" ]
	DiaSemana sabado = new DiaSemana() => [ diaSemana = "Sabado" ]
	DiaSemana domingo = new DiaSemana() => [ diaSemana = "Domingo" ]
	
	/** Crear direcciones */
	Direccion direccionHomeroMoe = new Direccion() => [
		calle = "25 de Mayo"
		altura = 100
		localidad = "San Martin"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]
	
	Direccion direccionBartMoe = new Direccion() => [
		calle = "25 de Mayo"
		altura = 100
		localidad = "San Martin"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]
	
	Direccion direccionHomeroEscuelaPrimaria = new Direccion() => [
		calle = "Av. Bartolomé Mitre"
		altura = 2725
		localidad = "Munro"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]
	
	Direccion direccionBartEscuelaPrimaria = new Direccion() => [
		calle = "Av. Bartolomé Mitre"
		altura = 2725
		localidad = "Munro"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]
	
	Direccion direccionHomeroTallerAutos = new Direccion() => [
		calle = "Thames"
		altura = 535
		localidad = "Villa Adelina"
		provincia = "Buenos Aires"
		latitud = 0.0
		longitud = 0.0
	]

	/** Crear estados */
	EstadoHojaDeRuta estadoHdrSuspendida = new EstadoHojaDeRuta() => [ nombre = "Suspendida" ]
	EstadoHojaDeRuta estadoHdrPendiente = new EstadoHojaDeRuta() => [ nombre = "Pendiente" ]
	EstadoHojaDeRuta estadoHdrEnCurso= new EstadoHojaDeRuta() => [ nombre = "En Curso" ]
	EstadoHojaDeRuta estadoHdrCompletada= new EstadoHojaDeRuta() => [ nombre = "Completada" ]
	EstadoRemito estadoRemitoCancelado = new EstadoRemito() => [ nombre = "Cancelado" ]
	EstadoRemito estadoRemitoPendiente = new EstadoRemito() => [ nombre = "Pendiente" ]
	EstadoRemito estadoRemitoEntregado = new EstadoRemito() => [ nombre = "Entregado" ]
	
	/** Crear fechas */
	LocalDate fechaDeHoy = LocalDate.now 
	LocalDate fechaDeManana = LocalDate.now.plusDays(1)
	
	/** Crear horas de apertura y cierre */
	LocalTime AM08 = LocalTime.of(8,0)
	LocalTime AM10 = LocalTime.of(10,0)
	LocalTime AM12 = LocalTime.of(12,0)
	LocalTime PM17 = LocalTime.of(17,0)
	LocalTime PM18 = LocalTime.of(18,0)
	
	/** Crear tiempos */
	Integer diezMinutos = 10
	
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
	public LocalDateTime fechaDeHoyPM18 = LocalDateTime.of(fechaDeHoy, PM18)
	public LocalDateTime fechaDeMananaAM08 = LocalDateTime.of(fechaDeManana, AM08)
	public LocalDateTime fechaDeMananaAM12 = LocalDateTime.of(fechaDeManana, AM12)
	
	/** Crear productos */
	Producto ventiladorHomero = new Producto() => [
		nombre = "Ventilador"
		precio_unitario = 1000.0
		descripcion = "Es un ventilador"
		url_imagen = "https://depor.com/resizer/UO7fzHpi6ZCPJXpfl9aFntHfIuE=/1200x900/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/SNF4HQTDJVCIFBU7NLYOH6BY7E.jpg"
		propietario = homero
	]
	
	Producto ventanaHomero = new Producto() => [
		nombre = "Ventana"
		precio_unitario = 500.0
		descripcion = "Es una ventana"
		url_imagen = "https://www.enriquedans.com/wp-content/uploads/2013/11/Ventana.jpg"
		propietario = homero
	]
	
	Producto puertaHomero = new Producto() => [
		nombre = "Puerta"
		precio_unitario = 2000.0
		descripcion = "Es una puerta"
		url_imagen = "http://d3ugyf2ht6aenh.cloudfront.net/stores/005/906/products/craffmaster_021-73b0d5aa0481dcbabd15132670274882-640-0.jpg"
		propietario = homero
	]
	
	Producto servicioTechista = new Producto() => [
		nombre = "Techista"
		precio_unitario = 200.0
		descripcion = "Servicio de techista"
		url_imagen = "https://techistareparaciones.com.ar/img/placeholder/techista_zona_norte_1.jpg"
		propietario = bart
	]
	
	Producto servicioElectricista = new Producto() => [
		nombre = "Electricista"
		precio_unitario = 500.0
		descripcion = "Servicio de electricista"
		url_imagen = "https://zonanorteanuncios.com/oc-content/uploads/26/2731_thumbnail.jpg"
		propietario = bart
	]
	
	Producto servicioGasista = new Producto() => [
		nombre = "Gasista"
		precio_unitario = 1000.0
		descripcion = "Servicio de gas"
		url_imagen = "https://miguiaargentina.com.ar/Imagenes/m/790273299-1-a-plomero-gasista-matriculado.jpeg"
		propietario = bart
	]
		
	/** Crear clientes */
	Cliente barMoeHomero = new Cliente() => [
		nombre = "Bar de Moe"
		observaciones = "Es un bar"
		cuit = "10301112225"
		promedio_espera = 10
		propietario = homero
		direccion = direccionHomeroMoe
	]
	
	Cliente tallerCachoHomero = new Cliente() => [
		nombre = "Taller de Cacho"
		observaciones = "Es un taller"
		cuit = "30501112560"
		promedio_espera = 25
		propietario = homero
		direccion = direccionHomeroTallerAutos
	]
	
	Cliente barMoeBart = new Cliente() => [
		nombre = "Bar de Moe"
		observaciones = "Es un bar"
		cuit = "10301112225"
		promedio_espera = 10
		propietario = bart
		direccion = direccionBartMoe
	]
	
	Cliente escuelaPrimariaHomero = new Cliente() => [
		nombre = "Escuela Primaria de Springfield"
		observaciones = "Es un una escuela"
		cuit = "10301112220"
		promedio_espera = 15
		propietario = homero
		direccion = direccionHomeroEscuelaPrimaria
	]
	
	Cliente escuelaPrimariaBart = new Cliente() => [
		nombre = "Escuela Primaria de Springfield"
		observaciones = "Es un una escuela"
		cuit = "10301112220"
		promedio_espera = 15
		propietario = bart
		direccion = direccionBartEscuelaPrimaria
	]
	
//	Cliente barMoe2 = new Cliente() => [
//		nombre = "Bar de Moe2"
//		observaciones = "Es un bar"
//		cuit = "10301112220"
//		promedio_espera = 10.0
//		propietario = homero
//		direccion = direccionMoe2
//	]
	
	/** 
	 * Crear disponibilidad
	 * NO BORRAR, SE USAN TODAS. AL CREAR LA DISPONIBILIDAD, SETEAMOS EN CLIENTE LA DISPONIBILIDAD 
	 */
	public Disponibilidad disponibilidadHomeroMoeLunes = new Disponibilidad(barMoeHomero, lunes, AM08, AM12)
	public Disponibilidad disponibilidadHomeroMoeMiercoles = new Disponibilidad(barMoeHomero, miercoles, AM08, AM12)
	public Disponibilidad disponibilidadHomeroMoeViernes = new Disponibilidad(barMoeHomero, viernes, AM08, AM12)
	
	public Disponibilidad disponibilidadHomeroTallerLunes= new Disponibilidad(tallerCachoHomero, lunes, AM12, PM17)
	public Disponibilidad disponibilidadHomeroTallerViernes= new Disponibilidad(tallerCachoHomero, viernes, AM10, PM18)
	
	public Disponibilidad disponibilidadHomeroEscuelaLunes = new Disponibilidad(escuelaPrimariaHomero, lunes, AM08, AM12)
	public Disponibilidad disponibilidadHomeroEscuelaMartes = new Disponibilidad(escuelaPrimariaHomero, martes, AM08, AM12)
	public Disponibilidad disponibilidadHomeroEscuelaMiercoles = new Disponibilidad(escuelaPrimariaHomero, miercoles, AM08, AM12)
	public Disponibilidad disponibilidadHomeroEscuelaJueves = new Disponibilidad(escuelaPrimariaHomero, jueves, AM08, AM12)
	public Disponibilidad disponibilidadHomeroEscuelaViernes = new Disponibilidad(escuelaPrimariaHomero, viernes, AM08, AM12)
	
	public Disponibilidad disponibilidadBartMoeLunes = new Disponibilidad(barMoeBart, lunes, AM08, AM12)
	public Disponibilidad disponibilidadBartMoeMiercoles = new Disponibilidad(barMoeBart, miercoles, AM08, AM12)
	public Disponibilidad disponibilidadBartMoeViernes = new Disponibilidad(barMoeBart, viernes, AM08, AM12)
	
	public Disponibilidad disponibilidadBartEscuelaLunes = new Disponibilidad(escuelaPrimariaHomero, lunes, AM08, AM12)
	public Disponibilidad disponibilidadBartEscuelaMartes = new Disponibilidad(escuelaPrimariaHomero, martes, AM08, AM12)
	public Disponibilidad disponibilidadBartEscuelaMiercoles = new Disponibilidad(escuelaPrimariaHomero, miercoles, AM08, AM12)
	public Disponibilidad disponibilidadBartEscuelaJueves = new Disponibilidad(escuelaPrimariaHomero, jueves, AM08, AM12)
	public Disponibilidad disponibilidadBartEscuelaViernes = new Disponibilidad(escuelaPrimariaHomero, viernes, AM08, AM12)
	
	/** Crear contacto */
	Contacto moeHomero = new Contacto() => [ 
		nombre = "Moe"
		apellido = "Syzlack"
		cliente = barMoeHomero
	]
	
	Contacto moeBart = new Contacto() => [ 
		nombre = "Moe"
		apellido = "Syzlack"
		cliente = barMoeBart
	]
	
	Contacto skinnerBart = new Contacto() => [ 
		nombre = "Seymour"
		apellido = "Skinner"
		cliente = escuelaPrimariaBart
	]
	
	Contacto skinnerHomero = new Contacto() => [ 
		nombre = "Seymour"
		apellido = "Skinner"
		cliente = escuelaPrimariaHomero
	]
	
	Contacto archundiaBart = new Contacto() => [ 
		nombre = "Super Intendente"
		apellido = "Archundia"
		cliente = escuelaPrimariaBart
	]
	
	Contacto cachoHomero = new Contacto() => [ 
		nombre = "Juan"
		apellido = "Perez"
		cliente = tallerCachoHomero
	]
	
	/** Crear telefonos */
	public Telefono telefonoMoeHomero = new Telefono() => [
		telefono = "1122223333"
		esPrincipal = true
		contacto = moeHomero
	]
	
	public Telefono telefonoMoeBart = new Telefono() => [
		telefono = "1122223333"
		esPrincipal = true
		contacto = moeBart
	]
	
	public Telefono telefonoSkinnerBart = new Telefono() => [
		telefono = "1155553333"
		esPrincipal = true
		contacto = skinnerBart
	]
	
	public Telefono telefonoSkinnerHomero = new Telefono() => [
		telefono = "1155553333"
		esPrincipal = true
		contacto = skinnerHomero
	]
	
	public Telefono telefonoArchundia = new Telefono() => [
		telefono = "1155559505"
		esPrincipal = true
		contacto = archundiaBart
	]
	
	public Telefono telefonoCacho = new Telefono() => [
		telefono = "1177773333"
		esPrincipal = true
		contacto = cachoHomero
	]
	
	/** Crear emails */
	public Email emailMoeHomero = new Email() => [
		direccion = "moe@mail.com"
		esPrincipal = true
		contacto = moeHomero
	]
	
	public Email emailMoeBart = new Email() => [
		direccion = "moe@mail.com"
		esPrincipal = true
		contacto = moeBart
	]
	
	public Email emailSkinnerBart = new Email() => [
		direccion = "skinner@mail.com"
		esPrincipal = true
		contacto = skinnerBart
	]
	
	public Email emailSkinnerHomero = new Email() => [
		direccion = "skinner@mail.com"
		esPrincipal = true
		contacto = skinnerHomero
	]
	
	public Email emailCachoHomero = new Email() => [
		direccion = "cachito@mail.com"
		esPrincipal = true
		contacto = cachoHomero
	]
	
	/** Crear hoja de rutas */
	HojaDeRuta hojaDeRutaHomeroHoy = new HojaDeRuta() => [
		fecha_hora_inicio = fechaDeHoyAM08
		fecha_hora_fin = fechaDeHoyAM12
		kms_recorridos = 0.0
		justificacion = ""
		estado = estadoHdrSuspendida
	]
	
	HojaDeRuta hojaDeRutaBartHoy = new HojaDeRuta() => [
		fecha_hora_inicio = fechaDeHoyAM08
		kms_recorridos = 0.0
		justificacion = ""
		estado = estadoHdrEnCurso
	]
	
//	HojaDeRuta hojaDeRutaManana = new HojaDeRuta() => [
//		fecha_hora_inicio = fechaDeMananaAM08
//		fecha_hora_fin = fechaDeMananaAM12
//		kms_recorridos = 0.0
//		justificacion = ""
//		estado = estadoHdrPendiente
//	]
	
	/** Crear remitos */
	Remito remitoHoyMoeHomero = new Remito() => [
		fechaDeCreacion = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = barMoeHomero
		estado = estadoRemitoEntregado
	]
	
	Remito remitoHoyCachoHomero = new Remito() => [
		fechaDeCreacion = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = tallerCachoHomero
		estado = estadoRemitoPendiente
	]
	
	Remito remitoHoySkinnerHomero = new Remito() => [
		fechaDeCreacion = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = escuelaPrimariaHomero
		estado = estadoRemitoPendiente
	]
	
	Remito remitoHoyMoeBart = new Remito() => [
		fechaDeCreacion = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = barMoeBart
		estado = estadoRemitoPendiente
	]
	
	Remito remitoHoySkinnerBart = new Remito() => [
		fechaDeCreacion = fechaDeHoy
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = escuelaPrimariaBart
		estado = estadoRemitoPendiente
	]
	
	Remito remitoMananaSkinnerBart = new Remito() => [
		fechaDeCreacion = fechaDeManana
		motivo = ""
		tiempo_espera = diezMinutos
		cliente = escuelaPrimariaBart
		estado = estadoRemitoPendiente
	]
	
	/** Crear PRs */
	ProductoRemito prMoeHomeroHoyVentilador = new ProductoRemito(remitoHoyMoeHomero, ventiladorHomero, 10, ventiladorHomero.precio_unitario, 0)
	ProductoRemito prMoeHomeroHoyPuerta = new ProductoRemito(remitoHoyMoeHomero, puertaHomero, 2, puertaHomero.precio_unitario, 10)
	ProductoRemito prSkinnerHomeroHoyVentana = new ProductoRemito(remitoHoySkinnerBart, ventanaHomero, 3, ventanaHomero.precio_unitario, 10)
	ProductoRemito prCachoHomeroHoyVentilador = new ProductoRemito(remitoHoyCachoHomero, ventiladorHomero, 2, ventiladorHomero.precio_unitario, 0)
	
	ProductoRemito prMoeBartHoyElectricista = new ProductoRemito(remitoHoySkinnerBart, servicioElectricista, 2, servicioElectricista.precio_unitario, 10)
	ProductoRemito prSkinnerBartHoyElectricista = new ProductoRemito(remitoHoyMoeBart, servicioElectricista, 4, servicioElectricista.precio_unitario, 0)
	ProductoRemito prSkinnerBartHoyGasista = new ProductoRemito(remitoHoySkinnerBart, servicioGasista, 1, servicioGasista.precio_unitario, 0)
	ProductoRemito prSkinnerBartMananaTechista = new ProductoRemito(remitoMananaSkinnerBart, servicioTechista, 4, servicioTechista.precio_unitario, 0)
	
	/** Crear comprobantes */
	ComprobanteEntrega comprobanteHomeroMoeRemitoHoy = new ComprobanteEntrega() => [
		nombre_completo = moeHomero.nombre.concat(" " + moeHomero.apellido)
		dni = "11222333"
		setFechaHoraEntrega = LocalDateTime.now
	]
	
	/**
	 * Es importante el orden en que se guardan los objetos
	 */
	def void init_app() {
		var Set<Usuario> repoUsuarioVacio = repositorioUsuarios.findAll().toSet;
		if (repoUsuarioVacio.length === 0){
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
			/** Guardando estados */
			servicioEstados.crearNuevoEstado(estadoHdrSuspendida)
			servicioEstados.crearNuevoEstado(estadoHdrPendiente)
			servicioEstados.crearNuevoEstado(estadoHdrEnCurso)
			servicioEstados.crearNuevoEstado(estadoHdrCompletada)
			servicioEstados.crearNuevoEstado(estadoRemitoCancelado)
			servicioEstados.crearNuevoEstado(estadoRemitoPendiente)
			servicioEstados.crearNuevoEstado(estadoRemitoEntregado)
			/** Guardando productos */
			servicioProductos.guardarProducto(ventiladorHomero)
			servicioProductos.guardarProducto(puertaHomero)
			servicioProductos.guardarProducto(ventanaHomero)
			servicioProductos.guardarProducto(servicioElectricista)
			servicioProductos.guardarProducto(servicioTechista)
			servicioProductos.guardarProducto(servicioGasista)
			/** Guardando clientes
			 * OJO: AL GUARDAR LOS CLIENTES TMB SE GUARDAN LAS DIRECCIONES
			 *  DISPONIBILIDAD, CONTACTOS, TELEFONOS, EMAILS
			 */
			servicioClientes.crearNuevoCliente(barMoeHomero)
			servicioClientes.crearNuevoCliente(barMoeBart)
			servicioClientes.crearNuevoCliente(escuelaPrimariaHomero)
			servicioClientes.crearNuevoCliente(escuelaPrimariaBart)
			servicioClientes.crearNuevoCliente(tallerCachoHomero)
			/** Guardando direcciones */
			/** Guardando disponibilidad */
			/** Guardando contactos */
			/** Guardando telefonos */
			/** Guardando emails */
			/** Guardando hoja de rutas */
			servicioHojaDeRuta.crearNuevaHdr(hojaDeRutaHomeroHoy)
			servicioHojaDeRuta.crearNuevaHdr(hojaDeRutaBartHoy)
//			servicioHojaDeRuta.crearNuevaHdr(hojaDeRutaManana)
			/** Guardando remitos */
			servicioRemitos.actualizarOCrearRemito(remitoHoyMoeHomero)
			servicioRemitos.actualizarOCrearRemito(remitoHoySkinnerHomero)
			servicioRemitos.actualizarOCrearRemito(remitoHoyCachoHomero)
			servicioRemitos.actualizarOCrearRemito(remitoHoyMoeBart)
			servicioRemitos.actualizarOCrearRemito(remitoHoySkinnerBart)
			servicioRemitos.actualizarOCrearRemito(remitoMananaSkinnerBart)
			/** Guardar PRs */
//			servicioProductoRemitos.crearNuevoProductoRemito(prMoeHomeroHoyVentilador)
//			servicioProductoRemitos.crearNuevoProductoRemito(prMoeHomeroHoyPuerta)
//			servicioProductoRemitos.crearNuevoProductoRemito(prCachoHomeroHoyVentilador)
//			servicioProductoRemitos.crearNuevoProductoRemito(prSkinnerHomeroHoyVentana)
//			servicioProductoRemitos.crearNuevoProductoRemito(prSkinnerBartHoyElectricista)
//			servicioProductoRemitos.crearNuevoProductoRemito(prMoeBartHoyElectricista)
//			servicioProductoRemitos.crearNuevoProductoRemito(prSkinnerBartMananaTechista)
			/** Actualizar remitos */
			hojaDeRutaHomeroHoy.remitos = #[remitoHoyMoeHomero, remitoHoySkinnerHomero, remitoHoyCachoHomero].toSet
			hojaDeRutaBartHoy.remitos = #[remitoHoyMoeBart, remitoHoySkinnerBart].toSet
			servicioHojaDeRuta.actualizarHdr(hojaDeRutaHomeroHoy.id_hoja_de_ruta, hojaDeRutaHomeroHoy)
			servicioHojaDeRuta.actualizarHdr(hojaDeRutaBartHoy.id_hoja_de_ruta, hojaDeRutaBartHoy)
			
			remitoHoyMoeHomero.productosDelRemito = #[prMoeHomeroHoyVentilador,prMoeHomeroHoyPuerta].toSet
			
//			remitoHoyMoeHomero.agregarProducto(prMoeHomeroHoyVentilador)
//			remitoHoyMoeHomero.agregarProducto(prMoeHomeroHoyPuerta)
//			remitoHoyMoeHomero.agregarProducto(prCachoHomeroHoyVentilador)
			remitoHoyMoeHomero.agregarProducto(prSkinnerHomeroHoyVentana)
			remitoHoyMoeHomero.agregarProducto(prMoeBartHoyElectricista)
			remitoHoyMoeHomero.agregarProducto(prSkinnerBartHoyGasista)
			remitoHoyMoeHomero.agregarProducto(prSkinnerBartMananaTechista)
			remitoHoyMoeHomero.comprobante = comprobanteHomeroMoeRemitoHoy
			/** Guardar Comprobantes */
			servicioComprobantes.crearNuevoComprobante(comprobanteHomeroMoeRemitoHoy)
//			servicioRemitos.actualizarOCrearRemito(remitoHoyMoeHomero)
//			servicioRemitos.actualizarOCrearRemito(remitoHoySkinnerHomero)
//			servicioRemitos.actualizarOCrearRemito(remitoHoyCachoHomero)
//			servicioRemitos.actualizarOCrearRemito(remitoHoyMoeBart)
//			servicioRemitos.actualizarOCrearRemito(remitoHoySkinnerBart)
//			servicioRemitos.actualizarOCrearRemito(remitoMananaSkinnerBart)
		}
		
	}

	override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Cargando datos iniciales")
		println("************************************************************************")
		init_app
		println("************************************************************************")
		println("Finalizó la carga de datos iniciales correctamente!")
		println("************************************************************************")
	}
	
}