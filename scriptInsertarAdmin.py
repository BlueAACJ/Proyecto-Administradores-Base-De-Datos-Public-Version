from passlib.context import CryptContext
import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

## en contrasenaEncriptada se debe pasar contexto.hash(contrasenaEncriptada)
def insertar_admin(cedula:str,nombres:str,apellidos:str,correo:str,
                    numeroTelefonico:str,usuario:str,contrasenaEncriptada:str,
                    estadoAdministrador:str,idSucursal:int,cursor):
    
    try:
        query = "INSERT INTO administrador (cedulaadministrador, nombresadministrador, apellidosadministrador, correoadministrador, numerotelefonoadministrador, usuario, contrasenia, estadoadministrador, idsucursal) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        values = (cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal)
        cursor.execute(query, values)
        connection.commit()
        print(f'{nombres} insertado con éxito')
    except Exception as e:
        print(f'Error al hacer a insercion /n {e}')

contexto = CryptContext(
    schemes=["pbkdf2_sha256"],
    default = "pbkdf2_sha256",
    pbkdf2_sha256__default_rounds = 30000
)

connection = mysql.connector.connect(
    host= os.getenv('MYSQL_HOST'),
    user= os.getenv('MYSQL_USER'),
    password= os.getenv('MYSQL_PASSWORD'),
    database= os.getenv('MYSQL_DB')
)

db = connection.cursor()

#1 '1', 'Mi viejo Ranchito', 'Rivas', '2560 2137', '1'
# cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('001-260104-1001L','Administrador','Mi Viejo Ranchito Rivas','MiviejoRanchitoRivas@gmail.com','25602137',
                'MiviejoRanchitoRivas',contexto.hash('MiviejoRanchitoRivas1'),'1',1,db) 

#2 '2', 'Mi viejo Ranchito', 'Catarina', '2558 0473', '1'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('002-260104-1001L','Administrador','Mi viejo Ranchito Catarina','MiviejoRanchitoCatarina@gmail.com','25580473',
                'MiviejoRanchitoCatarina',contexto.hash('MiviejoRanchitoCatarina1'),'1',2,db) 

#3 '3', 'Mi viejo Ranchito', 'Masaya', '2279 2865', '1'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('003-260104-1001L','Administrador','Mi viejo Ranchito Masaya','MiviejoRanchitoMasaya@gmail.com','22792865',
                'MiviejoRanchitoMasaya',contexto.hash('MiviejoRanchitoMasaya1'),'1',3,db) 

#4 '4', 'Mi viejo Ranchito', 'Galeria', '8590 3886', '1'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('004-260104-1001L','Administrador','Mi viejo Ranchito Galeria','MiviejoRanchitoGaleria@gmail.com','85903886',
                'MiviejoRanchitoGaleria',contexto.hash('MiviejoRanchitoGaleria1'),'1',4,db) 

#5 '5', 'El Zocalo', 'Masaya', '7530 6452', '2'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('121-260104-1001L','Administrador','El Zocalo Masaya','ElZocaloMasaya@gmail.com','75306452',
                'ElZocaloMasaya',contexto.hash('ElZocaloMasaya1'),'1',5,db) 

#6 '6', 'El Zocalo', 'Villa Fontana', '7530 6452', '2'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('366-260104-1001L','Administrador','El Zocalo Villa Fontana','ElZocaloVillaFontana@gmail.com','75306452',
                'ElZocaloVillaFontana',contexto.hash('ElZocaloVillaFontana1'),'1',6,db) 

#7 '7', 'El Zocalo', 'Galeria', '7530 6452', '2'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('009-260104-1001L','Administrador','El Zocalo Galeria','ElZocaloGaleria@gmail.com','75306452',
                'ElZocaloGaleria',contexto.hash('ElZocaloGaleria1'),'1',7,db) 

#8 '8', 'La Nani Cafe', 'Rivas', '8881 4246', '3'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('001-260104-0001P','Administrador','La Nani Cafe Rivas','LaNaniCafeRivas@gmail.com','88814246',
                'LaNaniCafeRivas',contexto.hash('LaNaniCafeRivas1'),'1',8,db) 

#9 '9', 'La Nani Cafe', 'Masaya', '2522 0239', '3'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('561-260104-1000U','Administrador','La Nani Cafe Masaya','LaNaniCafeMasaya@gmail.com','25220239',
                'LaNaniCafeMasaya',contexto.hash('LaNaniCafeMasaya1'),'1',9,db) 

#10 '10', 'Setenta Grados', 'Rivas', '8244 5592', '4'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('122-260104-1001L','Administrador','Setenta Grados Rivas','SetentaGradosRivas@gmail.com','82445592',
                'SetentaGradosRivas',contexto.hash('SetentaGradosRivas1'),'1',10,db) 

#11 '11', 'La Sureña', 'Rivas', '7620 5533', '5'
#cedula, nombres, apellidos, correo, numeroTelefonico, usuario, contrasenaEncriptada, estadoAdministrador, idSucursal
insertar_admin('366-260190-1001W','Administrador','La Sureña Rivas','LaSureñaRivas@gmail.com','76205533',
                'LaSureñaRivas',contexto.hash('LaSureñaRivas1'),'1',11,db) 

#Insertar gerente
insertar_admin('000-000000-0000A','Gerente','General','gerente@gmail.com','00112233','Gerente',
                contexto.hash('General'),'1',1,db)

db.close()
