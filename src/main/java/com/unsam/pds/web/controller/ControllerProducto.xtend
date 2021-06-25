package com.unsam.pds.web.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.http.MediaType
import org.springframework.http.HttpStatus
import java.util.List
import javax.transaction.Transactional
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import com.unsam.pds.servicio.ServicioProducto
import com.unsam.pds.dominio.entidades.Producto
import com.fasterxml.jackson.annotation.JsonView
import com.unsam.pds.web.view.View
import com.unsam.pds.dominio.Generics.PaginationResponse
import net.kaczmarzyk.spring.data.jpa.web.annotation.And
import net.kaczmarzyk.spring.data.jpa.domain.Equal
import net.kaczmarzyk.spring.data.jpa.domain.Like
import net.kaczmarzyk.spring.data.jpa.web.annotation.Spec
import net.kaczmarzyk.spring.data.jpa.domain.Between
import org.springframework.data.jpa.domain.Specification
import org.springframework.data.domain.Sort
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.http.HttpHeaders
import com.unsam.pds.dominio.Generics.GenericController
import com.unsam.pds.dominio.entidades.Usuario
import com.unsam.pds.dominio.Exceptions.NotFoundException
import com.unsam.pds.dominio.Exceptions.UnauthorizedException
import com.unsam.pds.servicio.ServicioCloudinary

@Controller
@CrossOrigin("*")
@RequestMapping("/producto")
class ControllerProducto extends GenericController<Producto> {

	Logger logger = LoggerFactory.getLogger(this.class)

	@Autowired ServicioProducto servicioProducto
	@Autowired ServicioCloudinary servicioCloudinary

	@JsonView(View.Producto.Lista)
	@GetMapping(path="/all/{idUsuario}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	def List<Producto> obtenerProductosActivosPorUsuario(@PathVariable("idUsuario") Long idUsuario) {
		logger.info("GET - Obtener todos los productos activos del id usuario " + idUsuario)
		servicioProducto.obtenerProductosActivosPorUsuario(idUsuario)
	}

	@GetMapping(produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(HttpStatus.OK)
	@JsonView(View.Producto.Lista)
	@ResponseBody
	def PaginationResponse<Producto> getAll(@And(#[
		@Spec(path="idProducto", params="id", spec=typeof(Equal)),
		@Spec(path="nombre", params="nombre", spec=typeof(Like)),
		@Spec(path="descripcion", params="descripcion", spec=typeof(Like)),
		@Spec(path="activo", params="activo", spec=typeof(Equal)),
		@Spec(path="precio_unitario", params=#["preciodesde", "preciohasta"], spec=typeof(Between))
	])
	Specification<Producto> spec, Sort sort, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = AgregarFiltro(spec, "propietario", usr)

		servicioProducto.getByFilter(specUsr, headers, sort)
	}

	@GetMapping(value="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@JsonView(View.Producto.Perfil)
	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	def Producto get(@PathVariable("id") Long id, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var specUsr = AgregarFiltro(null, "propietario", usr)

		specUsr = AgregarFiltro(specUsr, "idCliente", id)

		servicioProducto.obtenerProductoActivoPorId(id)
	}

	@PostMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.CREATED)
	@JsonView(View.Producto.Perfil)
	@ResponseBody
	@Transactional
	def Producto set(@RequestBody @JsonView(View.Producto.Post) Producto producto, @RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)

		producto.propietario = new Usuario()
		producto.propietario.idUsuario = usr
		//if (producto.url_imagen !== ''){
		producto.url_imagen = servicioCloudinary.upload(producto.url_imagen)
		//}

		servicioProducto.save(producto)
	}

	@PutMapping(consumes=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@JsonView(View.Producto.Perfil)
	@ResponseBody
	@Transactional
	def Producto update(@RequestBody @JsonView(View.Producto.Put) Producto producto,
		@RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		// prod Es de BD       -> imagen vieja
		// producto  del front -> se guarda en el BD
		var Producto prodBD = servicioProducto.getById(producto.idProducto)

		if (prodBD === null || !prodBD.activo)
			throw new NotFoundException

		if (prodBD.propietario === null || prodBD.propietario.idUsuario !== usr)
			throw new UnauthorizedException

		producto.propietario = producto.propietario === null ? prodBD.propietario : producto.propietario
		producto.activo = producto.activo === null ? prodBD.activo : producto.activo
		producto.nombre = producto.nombre === null ? prodBD.nombre : producto.nombre
		producto.precio_unitario = producto.precio_unitario === null ? prodBD.precio_unitario : producto.precio_unitario
		producto.descripcion = producto.descripcion === null ? prodBD.descripcion : producto.descripcion

		if (producto.url_imagen === null) {
			producto.url_imagen = prodBD.url_imagen // Borrar, si no me viene una imagen desde el front le pongo lo que hay en la BD
		} else if (prodBD.url_imagen.indexOf("|") != -1) { // puede ser nueva o vieja ambas tienen el |
			if (prodBD.url_imagen != producto.url_imagen) {
				logger.info("Es una imagen nueva")
				// elimino la imagen vieja de la nube
				var int index = producto.url_imagen.indexOf("|")
				var String key = producto.url_imagen.substring(0, index)
				var String image = producto.url_imagen.substring(index+1)
				
				//if (key != '-1') {
				servicioCloudinary.delete(key)
				//}			
				if (image != "") {
//					subo la imagen nueva y guardo el link en el producto
					producto.url_imagen = servicioCloudinary.upload(image)//imagen en base64
				}
			}
		}

		servicioProducto.save(producto)
	}

	@DeleteMapping(path="/{id}", produces=MediaType.APPLICATION_JSON_VALUE)
	@ResponseStatus(code=HttpStatus.OK)
	@ResponseBody
	def com.unsam.pds.dominio.Generics.ResponseBody delete(@PathVariable("id") Long id,
		@RequestHeader HttpHeaders headers) {
		var Long usr = getUsuarioIdFromLogin(headers)
		var Producto prod = servicioProducto.getById(id)

		if (prod === null || !prod.activo)
			throw new NotFoundException

		if (prod.propietario === null || prod.propietario.idUsuario !== usr)
			throw new UnauthorizedException

		prod.activo = false

		servicioProducto.save(prod)
//		logger.info("***public_url producto.url_imagen: ", prod.url_imagen)
//		servicioCloudinary.delete(prod.url_imagen.split("|").get(0))//TODOverificar el delete
		new com.unsam.pds.dominio.Generics.ResponseBody() => [
			code = HttpStatus.OK.toString
			message = "Producto eliminado exitosamente"
		]
	}
}
