package com.unsam.pds.servicio

import com.unsam.pds.dominio.Generics.GenericService
import com.unsam.pds.dominio.entidades.EstadoHojaDeRuta
import com.unsam.pds.dominio.entidades.HojaDeRuta
import com.unsam.pds.repositorio.RepositorioHojaDeRuta
import java.util.List
import javassist.NotFoundException
import javax.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.BeanUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import com.unsam.pds.repositorio.projectionQueries.IReporteInfoHojaDeRuta

@Service
class ServicioHojaDeRuta extends GenericService<HojaDeRuta, Long> {

	Logger logger = LoggerFactory.getLogger(ServicioHojaDeRuta)

	@Autowired  RepositorioHojaDeRuta repoHoja
	@Autowired ServicioEstado<EstadoHojaDeRuta> servEstado
	@Autowired ServicioRemito servRto

	def HojaDeRuta obtenerHdrPorId(Long idHdr) {
		repoHoja.findById(idHdr).orElseThrow([
			throw new NotFoundException("No existe el remito con el id " + idHdr)
		])
	}

	def List<HojaDeRuta> obtenerHojasDeRutaPorIdUsuario(Long idUsuario) {
		repoHoja.obtenerHojasDeRutaPorIdUsuario(idUsuario)
	}
	
	def List<IReporteInfoHojaDeRuta> obtenerInfoHojasDeRutaPorUsuario(Long idUsuario) {
		repoHoja.obtenerInfoHojasDeRutaPorUsuario(idUsuario)
	} 

	@Transactional
	def HojaDeRuta crearNuevaHdr(HojaDeRuta nuevaHdr) {
///////////// ESTA VALIDACION TIRA ERROR EN EL BOOTSTRAP :(
//		nuevaHdr.remitos.forEach [ rmo |
//			val rto = repoRto.getById(rmo.idRemito)
//			if (rto.hojaDeRuta !== null && rto.hojaDeRuta != nuevaHdr)
//				throw new com.unsam.pds.dominio.Exceptions.NotFoundException("El remito " + rto.idRemito +
//					" Esta asignado a otra Hoja de Ruta")
//		]

		val hoja = repoHoja.save(nuevaHdr)
		actualizarRemitos(nuevaHdr,hoja)
//		nuevaHdr.remitos.forEach [ rto |
//			val rt = servRto.getById(rto.idRemito)
//			rt.hojaDeRuta = hoja
//			servRto.save(rt)
//		]
		hoja
	}
	
	def actualizarRemitos(HojaDeRuta nuevaHdr, HojaDeRuta hoja) {
		nuevaHdr.remitos.forEach [ rto |
			val rt = servRto.getById(rto.idRemito)
			rt.hojaDeRuta = hoja
			servRto.save(rt)
		]
	}

	@Transactional
	def void actualizarHdr(Long idHdr, HojaDeRuta nuevaHdr) {
		//var hdrAModificar = obtenerHdrPorId(idHdr)
		logger.info("Actualizando la hoja de ruta del " + nuevaHdr.id_hoja_de_ruta)
		//BeanUtils.copyProperties(nuevaHdr, hdrAModificar)
		if (nuevaHdr.remitos.forall[rto|rto.estado.nombre != "Pendiente"]) {
			logger.info("COMO NO TIENE NINGUN REMITO CON ESTADO PENDIENTE CANCELO LA HDR")
			nuevaHdr.estado = this.getEstadoByNombre("Completada")
		}
		crearNuevaHdr(nuevaHdr)
		logger.info("Hoja de ruta actualizada!")
	}

	override HojaDeRuta getById(Long id) {
		repoHoja.findById(id).orElseThrow([
			throw new NotFoundException("No existe la HDR con el id " + id)
		])
	}


	@Transactional	
	def void delete(HojaDeRuta hdr, String causa) {
		hdr.estado = getEstadoByNombre("Suspendida")
		hdr.justificacion = causa
		repoHoja.save(hdr)
	}

	def EstadoHojaDeRuta getEstadoById(Long id) {
		servEstado.obtenerEstadoPorTipoAndId('estado_hoja_ruta', id)
	}
	
	def EstadoHojaDeRuta getEstadoByNombre(String nombre) {
		servEstado.getEstadoByNombre('estado_hoja_ruta',nombre)
	}
	
	def List<EstadoHojaDeRuta> getAllEstados() {
		servEstado.obtenerEstadosPorTipo('estado_hoja_ruta')
	}
}
