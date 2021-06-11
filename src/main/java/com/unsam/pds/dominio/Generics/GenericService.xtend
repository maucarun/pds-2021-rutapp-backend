package com.unsam.pds.dominio.Generics

import com.unsam.pds.dominio.Exceptions.NotFoundException
import java.util.Optional
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.domain.Specification
import org.springframework.http.HttpHeaders

abstract class GenericService<T, S> {

	@Autowired  GenericRepository<T,S> repo

	/**
	 * Devuelve la respuesta de una solicitud get a un servicio con los datos de paginación.-
	 * @param spec Lista de fitros a aplicar a la consulta
	 * @param headers Encabezado de la solicitud
	 * @param sort Ordenamiento de los datos (columna y tipo [ascendente o descendente])
	 * @param repo Repositorio al que se le hace la consulta 
	 * @return Resultado de la solicitud con datos de la paginación 
	 */
	def PaginationResponse<T> getByFilter(Specification<T> spec, HttpHeaders headers, Sort sort) {
		getByFilter(spec, buildPageRequest(headers, sort))
	}

	def T getById(S id) {
		repo.getById(id) as T 
	}

	def void deleteById(S id) {
		repo.deleteById(id)
	}

	def T save(T entity) {
		repo.save(entity)
	}

	def boolean existsById(S id) {
		repo.existsById(id)
	}

	def Pageable buildPageRequest(HttpHeaders headers, Sort sort) {
		var page = headers.containsKey("pagina") ? Integer.parseInt(headers.get("pagina").get(0)) : 0
		var size = headers.containsKey("cantidad") ? Integer.parseInt(headers.get("cantidad").get(0)) : 20
		PageRequest.of(page, size, sort);
	}

	def PaginationResponse<T> getByFilter(Specification<T> spec, Pageable pageable) {
		var Page<T> page = repo.findAll(spec, pageable);
		var content = page.content
		new PaginationResponse(page.totalElements, page.number.longValue, page.numberOfElements.longValue,
			pageable.offset, page.totalPages.longValue, content)
	}

	def T get(Specification<T> spec) {
		var Optional<T> oEntity = repo.findOne(spec);

		if (!oEntity.present)
			throw new NotFoundException

		oEntity.get
	}
}
