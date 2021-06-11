package com.unsam.pds.dominio.Generics

import org.springframework.data.jpa.repository.JpaSpecificationExecutor
import org.springframework.data.repository.CrudRepository
import org.springframework.data.repository.NoRepositoryBean

@NoRepositoryBean
abstract interface GenericRepository<T,S> extends CrudRepository<T, S>, JpaSpecificationExecutor<T> {
	def T getById(S id)
}
