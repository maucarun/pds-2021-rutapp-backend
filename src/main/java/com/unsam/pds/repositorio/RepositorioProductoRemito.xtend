package com.unsam.pds.repositorio

import org.springframework.data.repository.CrudRepository
import com.unsam.pds.dominio.entidades.ProductoRemito
import com.unsam.pds.dominio.keys.ProductoRemitoKey

interface RepositorioProductoRemito extends CrudRepository <ProductoRemito, ProductoRemitoKey> {
	
}