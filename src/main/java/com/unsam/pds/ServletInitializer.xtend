package com.unsam.pds

import org.springframework.boot.web.servlet.support.SpringBootServletInitializer
import org.springframework.boot.builder.SpringApplicationBuilder

class ServletInitializer extends SpringBootServletInitializer {
	
	override SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(Pds2021RutappBeApplication)
	}
	
}