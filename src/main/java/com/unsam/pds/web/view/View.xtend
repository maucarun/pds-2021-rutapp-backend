package com.unsam.pds.web.view

class View {
	static interface Usuario {

		static interface Perfil { }
		
	}
	
	static interface Producto {
		
		static interface Perfil { }
		
		static interface Lista { }
		
		static interface Post { }
		
		static interface Put extends Post { }
	}


	static interface Cliente {
		
		static interface Perfil { }
		
		static interface Lista { }
		
		static interface Post { }
		
		static interface Put extends Post { }
	}
	
	static interface Remito {
		
		static interface Perfil { }
		
		static interface Lista { }
		
		static interface Post { }
		
		static interface Put extends Post { }
	}
	
	static interface HojaDeRuta {
		
		static interface Perfil { }
		
		static interface Lista { }
		
		static interface Post { }
		
		static interface Put extends Post { }
	
	}
}