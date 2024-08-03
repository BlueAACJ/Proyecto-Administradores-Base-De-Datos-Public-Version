from flask import *
from funciones import *
from config import *
from datetime import *
from flask_mysqldb import MySQL

#configuracion de flask 
try:
    app = Flask(__name__)
    app.config.from_object(FlaskConfig)
except Exception as ex:
    print("Error durante la configuracion de Flask {}".format(ex))

# Configuración de MySQL
try:
    mysql = MySQL(app)
    app.config.from_object(MySQLConfig)
except Exception as ex:
    print("Error durante la conexión: {}".format(ex))

def funcion_notificaciones(tiporol):
    
    if tiporol == 'colaborador':
        
        db = mysql.connection.cursor()
        id_colaborador = session["id_colaborador"]
        # Numero de notificaciones 
        notificaciones = 0
        # Id de la solicitud del colaborador 
        query="SELECT IdSolicitudesPrestamos FROM SolicitudesPrestamos WHERE IdColaborador = %s"

        db.execute(query,[id_colaborador])
        solicitud_id = db.fetchone()

        # Estado de solicitud 
        query = "CALL NotificarEstadoSolicitud(%s)"
        db.execute(query,[solicitud_id])
        rows = db.fetchall()

        # Diccionario Estado de solicitud 
        columns = [column[0] for column in db.description]
        rows = [dict(zip(columns, row)) for row in rows]

        for row in rows:
            if row['Estado'] == 'A':
                estadosolicitud = "Aceptada"
                notificaciones += 1
            elif row['Estado'] == 'D':
                estadosolicitud = "Denegada"
                notificaciones += 1
            else:
                estadosolicitud=False

        # Fecha de Proximas Cuotas
        query = "call MostrarFechasCuotas(%s)"

        db.execute(query,[id_colaborador])
        rows = db.fetchall()

        # Diccionario de Fechas 
        columns = [column[0] for column in db.description]
        rows = [
            {columns[i]: (row[i].strftime('%d/%m/%Y') if isinstance(row[i], date) else row[i])
            for i in range(len(columns))}
            for row in rows
        ]

        # fecha actual formateada la fecha para mostrarla en día/mes/año
        fecha_actual = datetime.now()
        # Formatear la fecha para mostrarla en día/mes/año
        fecha_actual = fecha_actual.strftime('%d/%m/%Y')

        # Encuentra la siguiente fecha de pago
        siguiente_fecha_pago = False
        for pago in rows:
            fecha_pago = pago['FechaDePago']
            if fecha_pago < fecha_actual:
                siguiente_fecha_pago = fecha_pago
                notificaciones += 1
                break
        db.close()

        Todasnotificaciones = (siguiente_fecha_pago,estadosolicitud,notificaciones)
        return(Todasnotificaciones)
    
    elif tiporol == "admin":
        
        db = mysql.connection.cursor()
        id_administrador = session["id_administrador"]

        # Numero de notificaciones 
        notificaciones = 0

        # Notificar Fecha de registro de cuotas 
        fecha_actual = datetime.now()
        dia_actual = fecha_actual.day
        # Verificar si el día actual está en alguno de los rangos especificados
        if 13 <= dia_actual <= 15:
            reporte = "quincenal"
            notificaciones += 1
        elif 26 <= dia_actual <= 30:
            reporte = "mensual"
            notificaciones += 1
        else:
            reporte = False

        # Notificar solicitudes en espera 
        query="call MostrarSolicitudesPendientes(%s);"
        db.execute(query,[id_administrador])
        solicitudes = db.fetchall()

        numerodesolicitudes = 0

        for solicitudes in solicitudes:
            notificaciones += 1
            numerodesolicitudes += 1

        Todasnotificaciones = (notificaciones,numerodesolicitudes,reporte)

        db.close()
        return(Todasnotificaciones)
    