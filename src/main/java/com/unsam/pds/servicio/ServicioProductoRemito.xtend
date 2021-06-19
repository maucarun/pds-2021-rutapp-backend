package com.unsam.pds.servicio

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import com.unsam.pds.repositorio.RepositorioProductoRemito
import com.unsam.pds.dominio.entidades.ProductoRemito
import java.util.Set
import javax.transaction.Transactional
import com.unsam.pds.dominio.entidades.Remito

@Service
class ServicioProductoRemito {
	
	@Autowired RepositorioProductoRemito repositorioProductoRemitos
	
	@Transactional
	def void crearNuevoProductoRemito(ProductoRemito nuevoPR) {
		repositorioProductoRemitos.save(nuevoPR)
	}
	
	@Transactional
	def void guardarProductoRemito(Remito remito){
		var productosSinRemitos = remito.productosDelRemito
		remito.productosDelRemito = newHashSet
		
		productosSinRemitos.forEach[ pr | 
			println("remito id: " + remito.idRemito)
			println("id producto: " + pr.producto.idProducto)
			remito.productosDelRemito.add(new ProductoRemito(remito, pr.producto, pr.cantidad, pr.precio_unitario, pr.descuento))
		]
		
		repositorioProductoRemitos.saveAll(remito.productosDelRemito)
	}
}