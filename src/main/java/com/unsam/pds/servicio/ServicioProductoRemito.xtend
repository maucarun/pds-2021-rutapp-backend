package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioProductoRemito
import com.unsam.pds.dominio.entidades.ProductoRemito
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.Remito
import java.time.LocalDate

@Service
class ServicioProductoRemito {
	
	@Autowired RepositorioProductoRemito repositorioProductoRemitos
	
	def obtenerCantidadProductosVendidos(Long idUsuario, LocalDate fechaDesde, LocalDate fechaHasta) {
		repositorioProductoRemitos.findByCantidadProductosVendidos(idUsuario, fechaDesde, fechaHasta)
	}
	
	def obtenerCantidadProductosEntregados(Long idUsuario, LocalDate fechaDesde, LocalDate fechaHasta) {
		repositorioProductoRemitos.findByCantidadProductosEntregados(idUsuario, fechaDesde, fechaHasta)
	}
	
	@Transactional
	def void crearNuevoProductoRemito(ProductoRemito nuevoPR) {
		repositorioProductoRemitos.save(nuevoPR)
	}
	
	@Transactional
	def void guardarProductoRemito(Remito remito){
		var productosSinRemitos = remito.productosDelRemito
		remito.productosDelRemito = newHashSet
		
		productosSinRemitos.forEach[ pr | 
			remito.productosDelRemito.add(new ProductoRemito(remito, pr.producto, pr.cantidad, pr.precio_unitario, pr.descuento))
		]
		
		eliminarProductosDelRemitoPorIdRemito(remito.idRemito) /* Si no eliminas los PRs anteriores, los que agregas se suman */
		
		repositorioProductoRemitos.saveAll(remito.productosDelRemito)
	}
	
	@Transactional
	def void eliminarProductosDelRemitoPorIdRemito(Long idRemito) {
		repositorioProductoRemitos.deleteByRemito_idRemito(idRemito)
	}
}