package com.unsam.pds.servicio

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.cloudinary.json.JSONObject

@Service
class ServicioCloudinary {
	Logger logger = LoggerFactory.getLogger(this.class)
	Cloudinary cloudinary;

	Map<String, String> valuesMap = newHashMap

	new() {
		valuesMap.put("cloud_name", "rutapp");
		valuesMap.put("api_key", "617379246449317");
		valuesMap.put("api_secret", "CX3TY7j3oteZDX8L7wox7EVdoWM");
		cloudinary = new Cloudinary(valuesMap);
	}

//	Actualizar
	def String upload(String imagen) throws IOException {
		var JSONObject result = new JSONObject(cloudinary.uploader().upload(imagen, ObjectUtils.emptyMap()));
		logger.info("result.get(secure_url): ", result.get("secure_url"))
		logger.info("result.get(url): ", result.get("url"))
		return result.get("public_id").toString + '|' + result.get("secure_url").toString
	}

//	Eliminar
	def Map<String, String> delete(String id) throws IOException {
		logger.info("public_url: ", id)
		var Map<String, String> result = cloudinary.uploader().destroy(id, ObjectUtils.emptyMap());
		return result;
	}

//	Convertir
	def File convert(MultipartFile multipartFile) throws IOException {
		var File file = new File(multipartFile.getOriginalFilename());
		var FileOutputStream fo = new FileOutputStream(file);
		fo.write(multipartFile.getBytes());
		fo.close();
		return file;
	}
}
