from config import PasslibConfig
# Contexto de Passlib
contexto = PasslibConfig.CONTEXT

def sesion_admin(usuario:str, contrasena:str,cursor) -> bool:
    
    ########### consulta que retorna la contrasena de un colabordor por nombre de usuario ##########
    query = "SELECT contrasenia FROM administrador WHERE usuario = %s AND EstadoAdministrador = %s;"
    cursor.execute(query,(usuario,1))
    result = cursor.fetchone()
    
    if result != None:

        contrasenia_encriptada = result[0]

        if contexto.verify(contrasena,contrasenia_encriptada):
            return True
        else:
            return False

def sesion_colaborador(cedula:str, contrasena:str,cursor) -> bool:

    ########### consulta que retorna la contrasena de un colabordor por numero de cedula ##########
    query = "SELECT contrasenia FROM colaboradores WHERE cedulacolaborador = %s"
    cursor.execute(query,(cedula,))
    result = cursor.fetchone()
    
    if result != None:

        contrasenia_encriptada = result[0]
        
        if contexto.verify(contrasena,contrasenia_encriptada):
            return True
        else:
            return False
