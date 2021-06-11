> [Inicio](../README.md) > [Clientes](#)
----  
# Contenido
* [1 Path](#1-Path)
* [2 Descripción](#2-Descripción)
* [3 Métodos](#3-Métodos)
  * [Lista de clientes](#3.A-Lista-de-clientes)
    * [Descripción](#3.A.I-Descripción)
    * [Parámetros](#3.B.II-Parámetros)
      * [Parámetros del Header](#3.B.IV.1-Parámetros-del-Header)
      * [Parámetros del Path](#3.B.IV.2-Parámetros-del-Path)
    * [Códigos de respuesta](#3.B.V-Códigos-de-respuesta)
    * [Ejemplos](#3.B.VI-Ejemplos)
  * [Obtener un cliente](#4.A-Obtener-un-cliente)
    * [Descripción](#4.A.I-Descripción)
    * [Parámetros](#4.B.II-Parámetros)
      * [Parámetros del Header](#4.B.IV.1-Parámetros-del-Header)
      * [Parámetros del Path](#4.B.IV.2-Parámetros-del-Path)
    * [Códigos de respuesta](#4.B.V-Códigos-de-respuesta)
    * [Ejemplos](#4.B.VI-Ejemplos)
  * [Crear un cliente](#5.A-Crear-un-cliente)
    * [Descripción](#5.A.I-Descripción)
    * [Parámetros](#5.B.II-Parámetros)
      * [Parámetros del Header](#5.B.IV.1-Parámetros-del-Header)
    * [Códigos de respuesta](#5.B.V-Códigos-de-respuesta)
    * [Ejemplos](#5.B.VI-Ejemplos)
  * [Modificar un cliente](#6.A-Modificar-un-cliente)
    * [Descripción](#6.A.I-Descripción)
    * [Parámetros](#6.B.II-Parámetros)
      * [Parámetros del Header](#6.B.IV.1-Parámetros-del-Header)
    * [Códigos de respuesta](#6.B.V-Códigos-de-respuesta)
    * [Ejemplos](#6.B.VI-Ejemplos)
  * [Eliminar un cliente](#7.A-Eliminar-un-cliente)
    * [Descripción](#7.A.I-Descripción)
    * [Parámetros](#7.B.II-Parámetros)
      * [Parámetros del Header](#7.B.IV.1-Parámetros-del-Header)
      * [Parámetros del Path](#7.B.IV.2-Parámetros-del-Path)
    * [Códigos de respuesta](#7.B.V-Códigos-de-respuesta)
    * [Ejemplos](#7.B.VI-Ejemplos)

# 1 Path
{URL base}/cliente

# 2 Descripción
Acceso a los datos de Clientes

## 3 Métodos
  * [(GET) Lista de clientes](#3.A-Lista-de-clientes)
  * [(GET) Obtener un cliente](#4.A-Obtener-un-cliente)
  * [(POST) Crear un cliente](#5.A-Crear-un-cliente)
  * [(PUT) Modificar un cliente](#6.A-Modificar-un-cliente)
  * [(DELETE) Eliminar un cliente](#7.A-Eliminar-un-cliente)

## 3.A Lista de clientes

### 3.A.I Descripción
Retorna una lista de clientes con datos de la paginación

<table>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Endpoint</td><td>http://localhost:8080/cliente</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Método</td><td>GET</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Content-Type</td><td>application/json</td></tr>
</table>

### 3.B.II Parámetros

#### 3.B.IV.1 Parámetros del Header
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|usuario     |Texto    |Obligatorio |Usuario que realiza la consulta (se utiliza para la autenticación)
|password    |Texto    |Obligatorio |Password del usuario que realiza la consulta (se utiliza para la autenticación)
|pagina      |Texto    |Opcional    |Número de página solicitada
|cantidad    |Texto    |Opcional    |Cantidad de resultados por página

#### 3.B.IV.2 Parámetros del Path
|Nombre      |Formato  |Tipo     |Descripción
|------------|---------|---------|------------
|id          |Númerico |Opcional |Busca por el id del cliente
|nombre      |Texto    |Opcional |Busca por nombre del cliente
|cuit        |Texto    |Opcional |Busca por cuit del cliente
|activo      |Booleano |Opcional |Busca por estado del cliente
|esperadesde |Númerico |Opcional |Se utiliza junto con el parámetro esperahasta para buscar por tiempo de espera promedio
|esperahasta |Númerico |Opcional |Se utiliza junto con el parámetro esperadesde para buscar por tiempo de espera promedio
|sort        |Texto    |Opcional |Criterio de oden de los resultados se forma pon el nombre de parametro y tipo de orden (asc o desc)

### 3.B.V Códigos de respuesta
|Código|Descripción |Observaciones
|------|------------|-------------
|200   |Ok          |Solicitud correcta y respuesta satisfactoria.
|401   |Unauthorized|Credenciales de usuario invlidas

### 3.B.VI Ejemplos
1. Lista completa de clientes  (retorna codigo 200 "OK")
```
curl --location --request GET 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd1'
```   

2. Lista completa de clientes ordenada por id de cliente en forma descendente (retorna codigo 200 "OK")
```
curl --location --request GET 'http://localhost:8080/cliente?sort=idCliente,desc' \
--header 'usuario: homer' \
--header 'password: abcd1'
```   

3. Segunda página de la lista completa de clientes con 10 resultados por página (retorna codigo 200 "OK")
```
curl --location --request GET 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd1' \
--header 'pagina: 2' \
--header 'cantidad: 10'
```   

4. Solicitud con password de usuario incorrecta (retorna codigo 401 "UNAUTHORIZED")
```
curl --location --request GET 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd15'
```   

<!-- ########################################################################### -->

## #4.A Obtener un cliente

### 4.A.I Descripción
Retorna un clientes especifico a apartir de su id.-

<table>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Endpoint</td><td>http://localhost:8080/cliente/{id}</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Método</td><td>GET</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de respuesta</td><td>application/json</td></tr>
</table>

### 4.B.II Parámetros

#### 4.B.IV.1 Parámetros del Header
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|usuario     |Texto    |Obligatorio |Usuario que realiza la consulta (se utiliza para la autenticación)
|password    |Texto    |Obligatorio |Password del usuario que realiza la consulta (se utiliza para la autenticación)

#### 4.B.IV.2 Parámetros del Path
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|id          |Númerico |Obligatorio |Id del cliente consultado

### 4.B.V Códigos de respuesta
|Código|Descripción |Observaciones
|------|------------|-------------
|200   |Ok          |Solicitud correcta y respuesta satisfactoria.
|401   |Unauthorized|Credenciales de usuario invlidas
|404   |Not Found   |No se encontraron resultados

### 4.B.VI Ejemplos
1. Cliente con id 1  (retorna codigo 200 "OK")
```
curl --location --request GET 'http://localhost:8080/cliente/1' \
--header 'usuario: homer' \
--header 'password: abcd1'
```   

2. Cliente con id inexistente (retorna codigo 404 "NOT FOUND")
```
curl --location --request GET 'http://localhost:8080/cliente/1024' \
--header 'usuario: homer' \
--header 'password: abcd1'
```   

3. Solicitud con password de usuario incorrecta (retorna codigo 401 "UNAUTHORIZED")
```
curl --location --request GET 'http://localhost:8080/cliente/1024' \
--header 'usuario: homer' \
--header 'password: abcd15'
```  


<!-- ########################################################################### -->

## 5.A Crear un cliente

### 5.A.I Descripción
Realiza el alta de un cliente en el sistema y retorna los datos del cliente creado.-

<table>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Endpoint</td><td>http://localhost:8080/cliente</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Método</td><td>POST</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de solicitud</td><td>application/json</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de respuesta</td><td>application/json</td></tr>
</table>

### 5.B.II Parámetros

#### 5.B.IV.1 Parámetros del Header
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|usuario     |Texto    |Obligatorio |Usuario que realiza la consulta (se utiliza para la autenticación)
|password    |Texto    |Obligatorio |Password del usuario que realiza la consulta (se utiliza para la autenticación)

### 5.B.V Códigos de respuesta
|Código|Descripción       |Observaciones
|------|------------------|-------------
|200   |Ok                |Solicitud correcta y respuesta satisfactoria.
|401   |Unauthorized      |Credenciales de usuario invlidas
|404   |Not Found         |No se encontraron resultados
|415   |Unsupported Media |El Content-Type de la solicitud no es application/json
|400   |Bad Request       |Cuerpo de la solicitud mal formado 

### 5.B.VI Ejemplos
1. Cliente con id 1  (retorna codigo 200 "OK")
```
curl --location --request POST 'http://localhost:8080/cliente' \
--header 'usuario: elbarto' \
--header 'password: abcd1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "nombre": "Zurdario",
    "observaciones": "Venta de productos para zurdos",
    "cuit": "95301452336",
    "promedio_espera": 5.0,
    "activo": true,
    "direccion": {
        "calle": "Cochabamba",
        "altura": 1020,
        "localidad": "Villa Ballester",
        "provincia": "Buenos Aires",
        "latitud": 0.0,
        "longitud": 0.0
    },
    "disponibilidades": [
        {
            "idDisponibilidad": {
                "idDiaSemana": 1
            },
            "diaSemana": {
                "dia_semana": "Lunes"
            },
            "hora_apertura": "11:00:00",
            "hora_cierre": "13:00:00"
        }]
}'
```   

2. Solicitud con password de usuario incorrecta (retorna codigo 401 "UNAUTHORIZED")
```
curl --location --request POST 'http://localhost:8080/cliente' \
--header 'usuario: elbarto' \
--header 'password: abcd15' \
--header 'Content-Type: application/json' \
--data-raw '{
    "nombre": "Zurdario",
    "observaciones": "Venta de productos para zurdos",
    "cuit": "95301452336",
    "promedio_espera": 5.0,
    "activo": true,
    "direccion": {
        "calle": "Cochabamba",
        "altura": 1020,
        "localidad": "Villa Ballester",
        "provincia": "Buenos Aires",
        "latitud": 0.0,
        "longitud": 0.0
    },
    "disponibilidades": [
        {
            "idDisponibilidad": {
                "idDiaSemana": 1
            },
            "diaSemana": {
                "dia_semana": "Lunes"
            },
            "hora_apertura": "11:00:00",
            "hora_cierre": "13:00:00"
        }]
}'
```  


<!-- ########################################################################### -->

## 6.A Modificar un cliente

### 6.A.I Descripción
Modifica un cliente del sistema y retorna los datos del cliente modificado.-

<table>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Endpoint</td><td>http://localhost:8080/cliente</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Método</td><td>PUT</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de solicitud</td><td>application/json</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de respuesta</td><td>application/json</td></tr>
</table>

### 6.B.II Parámetros

#### 6.B.IV.1 Parámetros del Header
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|usuario     |Texto    |Obligatorio |Usuario que realiza la consulta (se utiliza para la autenticación)
|password    |Texto    |Obligatorio |Password del usuario que realiza la consulta (se utiliza para la autenticación)

### 6.B.V Códigos de respuesta
|Código|Descripción       |Observaciones
|------|------------------|-------------
|200   |Ok                |Solicitud correcta y respuesta satisfactoria.
|401   |Unauthorized      |Credenciales de usuario invlidas
|404   |Not Found         |No se encontraron resultados
|415   |Unsupported Media |El Content-Type de la solicitud no es application/json
|400   |Bad Request       |Cuerpo de la solicitud mal formado 

### 6.B.VI Ejemplos
1. Modificación correcta del calpo 'Observaciones' del cliente con id 1  (retorna codigo 200 "OK")
```
curl --location --request PUT 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd1' \
--header 'pagina: 0' \
--header 'Content-Type: application/json' \
--data-raw '{
    "idCliente": 1,
    "observaciones": "Esto es una prueba"
}'
```   

2. Modificación de un cliente sin enviar el id del mismo (retorna codigo 404 "NOT FOUND")
```
curl --location --request GET 'http://localhost:8080/cliente/1024' \
curl --location --request PUT 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd1' \
--header 'pagina: 0' \
--header 'Content-Type: application/json' \
--data-raw '{
    "observaciones": "Esto es una prueba"
}'
```  

3. Solicitud con password de usuario incorrecta (retorna codigo 401 "UNAUTHORIZED")
```
curl --location --request PUT 'http://localhost:8080/cliente' \
--header 'usuario: homer' \
--header 'password: abcd15' \
--header 'pagina: 0' \
--header 'Content-Type: application/json' \
--data-raw '{
    "idCliente": 1,
    "observaciones": "Esto es una prueba"
}'
```  



<!-- ########################################################################### -->

## 7.A-Eliminar-un-cliente

### 7.A.I Descripción
Realiza la baja lógica de un cliente en el sistema.-

<table>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Endpoint</td><td>http://localhost:8080/cliente</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Método</td><td>DELETE</td></tr>
<tr><td style="font-weight: bold; color: #0366d7 !important;">Tipo de respuesta</td><td>application/json</td></tr>
</table>

### 7.B.II Parámetros

#### 7.B.IV.1 Parámetros del Header
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|usuario     |Texto    |Obligatorio |Usuario que realiza la consulta (se utiliza para la autenticación)
|password    |Texto    |Obligatorio |Password del usuario que realiza la consulta (se utiliza para la autenticación)

#### 7.B.IV.2 Parámetros del Path
|Nombre      |Formato  |Tipo        |Descripción
|------------|---------|------------|------------
|id          |Númerico |Obligatorio |Id del cliente consultado

### 7.B.V Códigos de respuesta
|Código|Descripción       |Observaciones
|------|------------------|-------------
|200   |Ok                |Solicitud correcta y respuesta satisfactoria.
|401   |Unauthorized      |Credenciales de usuario invlidas
|404   |Not Found         |Id del cliente inexistente

### 6.B.VI Ejemplos
1. Eliminación correcta del cliente con id 1  (retorna codigo 200 "OK")
```
curl --location --request DELETE 'http://localhost:8080/cliente/1' \
--header 'usuario: homer' \
--header 'password: abcd1' \
--header 'pagina: 0'
```   
 

2. Eliminación de un cliente con id inexitente (retorna codigo 404 "NOT FOUND")
```
curl --location --request DELETE 'http://localhost:8080/cliente/1546' \
--header 'usuario: homer' \
--header 'password: abcd1' \
--header 'pagina: 0'servaciones": "Esto es una prueba"
}'
```  

3. Solicitud con password de usuario incorrecta (retorna codigo 401 "UNAUTHORIZED")
```
curl --location --request DELETE 'http://localhost:8080/cliente/1' \
--header 'usuario: homer' \
--header 'password: abcd15' \
```  
----
> [Inicio](../README.md) > [Clientes](#)
