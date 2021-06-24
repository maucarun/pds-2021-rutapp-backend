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
class Bootstrap implements InitializingBean {

	def void init_app() {
		
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