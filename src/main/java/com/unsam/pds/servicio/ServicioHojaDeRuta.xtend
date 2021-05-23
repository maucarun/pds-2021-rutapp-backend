package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioHojaDeRuta
import com.unsam.pds.dominio.entidades.HojaDeRuta
import javax.transaction.Transactional
import javassist.NotFoundException
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.BeanUtils

@Service
class ServicioHojaDeRuta {
	
	Logger logger = LoggerFactory.getLogger(ServicioHojaDeRuta)
	
	@Autowired RepositorioHojaDeRuta repositorioHojaDeRutas
	
	def HojaDeRuta obtenerHdrPorId(Long idHdr) {
		repositorioHojaDeRutas.findById(idHdr).orElseThrow([
			throw new NotFoundException("No existe el remito con el id " + idHdr)
		])
	}
	
	@Transactional
	def void crearNuevaHdr(HojaDeRuta nuevaHdr) {
		repositorioHojaDeRutas.save(nuevaHdr)
	}
	
	@Transactional
	def void actualizarHdr(Long idHdr, HojaDeRuta nuevaHdr) {
		var hdrAModificar = obtenerHdrPorId(idHdr)
		logger.info("Actualizando la hoja de ruta del " + hdrAModificar.fecha_hora_inicio)
		BeanUtils.copyProperties(nuevaHdr, hdrAModificar)
		crearNuevaHdr(nuevaHdr)
		logger.info("Hoja de ruta actualizada!")
	}
}