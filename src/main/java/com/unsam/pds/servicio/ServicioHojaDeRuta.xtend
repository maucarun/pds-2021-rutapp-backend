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
		nuevaHdr.remitos.forEach [ rto |
			val rt = servRto.getById(rto.idRemito)
			rt.hojaDeRuta = hoja
			servRto.save(rt)
		]
		hoja
	}

	@Transactional
	def void actualizarHdr(Long idHdr, HojaDeRuta nuevaHdr) {
		var hdrAModificar = obtenerHdrPorId(idHdr)
		logger.info("Actualizando la hoja de ruta del " + hdrAModificar.fecha_hora_inicio)
		BeanUtils.copyProperties(nuevaHdr, hdrAModificar)
		crearNuevaHdr(nuevaHdr)
		logger.info("Hoja de ruta actualizada!")
	}

	override HojaDeRuta getById(Long id) {
		repoHoja.findById(id).get
	}


	@Transactional	
	def void delete(HojaDeRuta hdr, String causa) {
		hdr.estado = getEstadoByNombre("Suspendida")
		hdr.justificacion = causa
		repoHoja.save(hdr)
	}

	@Transactional
	
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
