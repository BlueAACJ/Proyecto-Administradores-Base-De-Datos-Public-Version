from email.mime.text import MIMEText
import base64
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

SCOPES = ["https://www.googleapis.com/auth/gmail.send"]

def send_mail_google(correoColaborador,Nombres,Cedula,Password):

    # identificamos nuestras credenciales de acceso a la api mediante el json y el scope
    # donde señalamos el tipo de permiso que vamos a dar a la persona que se identifique 
    flow = InstalledAppFlow.from_client_secrets_file('credentials.json', SCOPES)
    creds = flow.run_local_server()
    # nombre de la api, version, credenciales   
    service = build('gmail', 'v1', credentials=creds)

    # creamos el cuerpo del mensaje
    message = MIMEText(f'''ESTE ES UN MENSAJE AUTOMATICO\nHola: {Nombres}\nBienvenido al sistema de préstamos de GrupoTalse\nSus credenciales por defecto para acceder al sistema:\nContraseña: {Password}\n\nNOTA: AL INGRESAR AL SISTEMA PUEDE CAMBIAR SU CONTRASEÑA POR DEFECTO POR UNA CONTRASEÑA DE SU PREFERENCIA''')
    
    message['to'] = correoColaborador
    message['subject'] = 'Registrado'

    # Codificar el mensaje en base64, gmail no reconoce los textos planos para envíos de emails
    raw_message = base64.urlsafe_b64encode(message.as_bytes()).decode('utf-8')
    body = {'raw': raw_message}

    # Enviar el mensaje
    try:
        message = (service.users().messages().send(userId="me", body=body).execute())
        print('Mensaje enviado')
    except HttpError as error:
        print(f'Error: {error}')
    