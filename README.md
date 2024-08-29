# Proyecto-Administradores-Base-De-Datos

Leer notas.txt

El Sistema Web de Administración de Préstamos de Grupo Talse está diseñado para gestionar los préstamos bajo nomina 
otorgados a los colaboradores de la empresa. Esta aplicación web facilita la solicitud, aprobación y administración 
de los préstamos, reduciendo la carga administrativa y optimizando las tareas relacionadas con el control de cuotas, 
intereses y pagos.
Este sistema web automatiza y digitaliza todo el ciclo de vida de los préstamos, desde la solicitud inicial hasta la 
gestión de pagos y reportes, eliminando procesos manuales ineficientes y reduciendo la posibilidad de errores. 
A través de una interfaz intuitiva y segura, tanto colaboradores como administradores pueden interactuar fácilmente 
con el sistema, facilitando la solicitud, evaluación y aprobación de préstamos en tiempo real.

- Manual de Usuario
En este archivo se encuentra el manual de usuario del sistemas, ademas todas las funcionalidades implementadas en el 
mismo como la matriz CRUD de colaboradores y administradores, solicitud de prestamos, un dashboard basico en la vista 
de administrador general, etc.

## Tecnologías Utilizadas

Lenguajes:<br />
<img src="ImagenesREADME/python.png" width="100" height="100">      <img src="ImagenesREADME/Javascript.png" width="100" height="100"><br />

Framework:<br />
<img src="ImagenesREADME/flask.png" width="100" height="100"><br />

Base de Datos:<br />
<img src="ImagenesREADME/MySQL.png" width="130" height="100"><br />

Herramientas: <br />
<img src="ImagenesREADME/Code.png" width="125" height="100"> <img src="ImagenesREADME/html.svg.png" width="100" height="100"> <img src="ImagenesREADME/git.png" width="100" height="100"> <img src="ImagenesREADME/css.png" width="75" height="100">

- API
    - Documentacion de API de Google para el envio de correos 
        https://developers.google.com/gmail/api/guides/sending

- Estructura del repositorio:
    - Querys
      - Contiene las querys de creacion de la BD, las inserciones de las distintas sucursales de la empresa, los procedimientos de almacenado implementados en el sistema y un script para generar registros antiguos para hacer pruebas.

    - statics
      - Contiene las imagenes usadas en el sistema, el JS utilizado para validaciones de distintos formularios y scripts de estilo para la impresion de tablas ademas de los estilos css utilizados en el proyecto.

    - templates
      - Contiene los templates del proyecto.

    - application
      - El archivo principal con la aplicación de flask.

    - config
      - Este código carga configuraciones específicas (como la configuración de Flask, la conexión a MySQL y la 
        configuración de Passlib para el hashing seguro de contraseñas) desde variables de entorno definidas en un archivo .env, 
        lo que facilita la configuración y la gestión de secretos sensibles fuera del código fuente.

    - funciones_notificaciones
      - El archivo con la funcion encargadas de crear las notificaciones a los usuarios.

    - funcioncontrato
      - El archivo con la funcion encargada de crear el PDF con el contrato de prestamo.

    - funcioncrearreportededucciones
      - El archivo con la funcion encargada de crear el reporte de deducciones.

    - funcioncrearreporteprestamo
      - El archivo con las funcion encargada de crear un reporte detallado de un prestamo especifico.

    - funciones
      - Archivo con las funciones utilizadas a lo largo del proyecto.

    - funcionsGmail
      - Archivo con la funcion que envia los correos electronicos con la API de Google.

    - funcionesLogin
      - El archivo con las funciones encargadas de diferenciar los distintos tipos de Roles presentes en el sistema.

    - scriptInsertarAdmin
      - Archivo con un script diseñado para crear a los admistradores de las sucursales. 

    - scriptInsertarColaborador
      - Archivo con un script diseñado para crear colaboradores de prueba.
