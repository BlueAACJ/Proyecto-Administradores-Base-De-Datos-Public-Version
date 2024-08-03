from passlib.context import CryptContext
import mysql.connector
from passlib.context import CryptContext
from flask import *
from funciones import *
from config import *
from datetime import *

load_dotenv()

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

## en contrasenaEncriptada se debe pasar contexto.hash(contrasenaEncriptada)
def insertar_colaborador(fechaContratacion:str,cedula:str,nombres:str,apellidos:str,salario:float,tipoContrato:str,estadoCrediticio:str,
                        correo:str,numeroTelefonico:str,contraseniaEncriptada:str, estadocolaborador:str, idSucursal:int,cursor):
    
    try:
        query = "INSERT INTO colaboradores (fechacontratacion, cedulacolaborador, nombrescolaborador, apellidoscolaborador, salariocolaborador, tipodecontrato, estadocrediticio, correocolaborador, numerotelefonocolaborador, contrasenia, estadocolaborador, idsucursal) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        values = (fechaContratacion,cedula,nombres,apellidos,salario,tipoContrato,estadoCrediticio,correo,numeroTelefonico,contraseniaEncriptada, estadocolaborador, idSucursal)
        cursor.execute(query, values)
        db.commit()
        print(f'{nombres} insertado con éxito')
    except Exception as e:
        print(f'Error al hacer la insersion /n{e}')

insertar_colaborador('2023-04-21','001-122398-1002K','Juan Ramon','Castro Peralta',10000.00,'F','0',
                'juancastro@gmail.com','22112211',contexto.hash('juan123'), 'A', 1,db)               
insertar_colaborador('2023-01-13', '561-260590-1002L', 'Juan Franciso', 'Perez Lozano', 9000.00, 'F', '0', 
                'juanperez564@gmail.com', '8452 5698',contexto.hash('juanperez564'), 'A',1,db)     
insertar_colaborador('2023-02-10', '201-150494-2556P', 'Maria Lucia', 'Gomez Solorzano', 8000.00, 'T', '0',
                'maria.Solor132@gmail.com', '7896 5832',contexto.hash('maria.solor'),'A', 2,db)  
insertar_colaborador('2023-01-13', '401-010985-1009W', 'Carlos Roberto', 'Lopez Amador', 14000.00, 'F', '0',
                'carlolopez44$$@yahoo.com', '8896 7450',contexto.hash('carlolopez'), 'A',3,db)   
insertar_colaborador('2023-07-17', '001-301100-2005Q', 'Ana Lucia', 'Martinez Ruiz', 9500.00, 'F', '0', 
                'ana2martinez@gmail.com', '8387 5521',contexto.hash('ana2martinez'), 'A', 4,db)
insertar_colaborador('2022-01-13', '401-241295-3000P', 'Pedro Pablo', 'Rodriguez Ocampo', 13000.00, 'F', '0',
                'pedrocampo99@yahoo.com', '7793 6842',contexto.hash('pedrocampo'), 'A',5,db)
insertar_colaborador('2022-02-10', '001-170980-4500A', 'Laura Paola', 'Hernandez Zuniga', 9000.00, 'T', '0',
                'lauraPaohernandez@gmail.com', '7374 5664',contexto.hash('laurapao'), 'A',6,db)
insertar_colaborador('2023-04-18', '001-220796-1056R', 'Sergio Isaac', 'Diaz Perroso', 20000.00, 'F', '0',
                'sergioktm232@gmail.com', '7890 1234',contexto.hash('sergioktm'),'A', 7,db)
insertar_colaborador('2024-01-01', '561-080490-2669C', 'Annia Isabel', 'Sanchez Pavon', 10000.00, 'F', '0',
                'isabelsanchez1223@hotmail.com', '8901 2945',contexto.hash('isabelsanchez'),'A',8,db)
insertar_colaborador('2024-01-20', '561-010180-0056H', 'Javier Jose', 'Ramirez Rivas', 11000.00, 'F', '0', 
                'javramirezrr@yahoo.com', '9012 5598',contexto.hash('javramirez'),'A',9,db)
insertar_colaborador('2023-03-13', '001-230299-5226D', 'Carmen Maria', 'Gonzalez Romero', 8500.00, 'F', '0',
                'carmen.gonzalez@gmail.com', '8896 9632',contexto.hash('carmen.gonzalez'),'A',10,db)
insertar_colaborador('2024-04-08', '201-291184-1006L', 'Raul Ramiro', 'Ortega Murillo', 18000.00, 'F', '1', 
                'raul.ortega@gmail.com', '9636 6625',contexto.hash('raul.ortega'),'A',11,db)
insertar_colaborador('2024-01-01', '401-090879-1336Q', 'Patricia Lorena', 'Vargas Trujillo', 7800.00, 'T', '1', 
                'patriciavargas453@yahoo.com', '7999 6651',contexto.hash('patriciavargas'),'A',1,db)
insertar_colaborador('2022-01-01', '001-160695-1359k', 'Fernando Jose', 'Mendoza Gutierrez', 12000.00, 'T', '1', 
                'fernando.mendoza249@yahoo.com', '9658 8564',contexto.hash('fernando.mendoza'),'A',2,db)
insertar_colaborador('2023-01-01', '409-220996-2005W', 'Ana Lucia', 'Cruz Iraeta', 9500.00, 'T', '1', 
                'luciaewcruz@gmail.com', '7798 5635',contexto.hash('lucia'),'A',3,db)
insertar_colaborador('2024-01-01', '561-220979-1009F', 'Oscar Armando', 'Reyes Lozano', 10000.00, 'F', '1', 
                'oscarreyes985@yahoo.com', '7996 5594',contexto.hash('oscarreyes'),'A', 4,db)

db.close()
