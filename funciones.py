from decimal import Decimal,ROUND_DOWN
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta 
import random

def crear_diccionario(db):

    rows = db.fetchall()
    # Creacion del diccionario 
    columns = [column[0] for column in db.description]
    rows = [dict(zip(columns, row)) for row in rows]

    return rows

def calcular_monto_cuota(diccionario):

    monto_cuota = []

    for i in diccionario:
        
        plazo_pago = i['PlazoDePago_Meses'] * 2
        capital_total = i['Capital']
        intereses = i['Intereses']
        pago_total = capital_total + (capital_total * intereses * plazo_pago)
        pago_por_cuota = pago_total / plazo_pago
        monto_cuota.append(round(pago_por_cuota, 2))

    return monto_cuota

def calcular_interes_cuota(diccionario):
    interes_cuota = []
    for i in diccionario:
        plazo_pago = i['PlazoDePago_Meses'] * 2
        capital_total = i['Capital']
        intereses = i['Intereses']
        pago_total = (capital_total * intereses * plazo_pago)
        pago_por_cuota = pago_total / plazo_pago
        interes_cuota.append(round(pago_por_cuota, 2))

    return interes_cuota

def calcular_pagos(datos,fechas_pago,cuotas_deducidas):
    
    resultados = []
    primer_diccionario = datos[0]

    plazo_pago = primer_diccionario['PlazoDePago'] * 2
    capital_total = primer_diccionario['Capital']
    tasa_interes = primer_diccionario['Intereses']
    
    ###### 
    pago_total = capital_total + (capital_total * tasa_interes * plazo_pago)
    pago_por_cuota = pago_total / plazo_pago
    
    primer_saldo = capital_total
    saldo = primer_saldo
    pago_por_cuota_sin_intereses = primer_diccionario['Capital'] / plazo_pago

    # Anualidad ordinaria 
    pmt = (tasa_interes* capital_total) / (1 - (1 + tasa_interes) ** -plazo_pago)
    interes = tasa_interes*saldo
    
    interes_acumulado = 0
    
    for i in range(plazo_pago):
        
        fecha_pago = fechas_pago[i]
        fecha_formateada = fecha_pago[0].strftime('%Y-%m-%d')
        
        if datos[i]['EstadoCuota'] == 'D':
            
            if i == plazo_pago - 1:  # Última cuota
                pago = pago_por_cuota_sin_intereses
            elif saldo < pago_por_cuota_sin_intereses:
                pago = pago_por_cuota_sin_intereses
            else:
                pago = pago_por_cuota_sin_intereses

            interes = 0
            capital = pago 
            saldo -= (capital)
            pmt = capital
            
            if datos[i]['EstadoCuota'] == 'D':
                interes_acumulado += interes

        else:
            
            if i == plazo_pago - 1:  # Última cuota
                pago = saldo
            elif saldo < pago_por_cuota:
                pago = saldo
            else:
                pago = pago_por_cuota
            
            interes = tasa_interes*saldo  
            capital = pmt - interes
            saldo -= (capital)

            if cuotas_deducidas > 0:
                # este caso es para cuando hay cuotas deducidas
                pago_por_cuota_sin_intereses = saldo / cuotas_deducidas
            
            if datos[i]['EstadoCuota'] == 'C':
                interes_acumulado += interes

        resultados.append({
            'Fecha': fecha_formateada,
            'Pagos': round(pmt, 2),
            'Interes': round(interes, 2),
            'Capital': round(capital, 2),
            'Saldo': round(saldo, 2),
            'PrimerSaldo': round(primer_saldo,2),
            'contador': (i+1),
            'EstadoCuota': datos[i]['EstadoCuota'],
            'InteresAcumulado' : round(interes_acumulado,2)  
        })

    return resultados

#retorna una contraseña con las iniciales + 4 números aleatorios
def crear_contrasenia_colaborador(NombresColaborador:str,ApellidosColaborador:str) -> str:
    
    nueva_contrasenia = ''
    cadena = ' ' + NombresColaborador.strip() + ' ' + ApellidosColaborador.strip()
    caracter_anterior=''
    i = 0
    nums = ''

    while(True):
        
        if i < 4:
            nums += str(random.randint(0, 9))

        caracter_anterior = cadena[i]
        i+=1

        if (caracter_anterior == ' '):
            nueva_contrasenia += cadena[i]
        
        if (len(cadena)-1 == i):
            break
    
    password = nueva_contrasenia+nums

    if len(password) < 8:
        return password
    else:
        return (password[0:7])

"""
    Para los colaboradores que tienen menos de tres anios trabajando en la empresa su
    liquidacion es igual al aguinaldo (Salario Mensual)

    Para los colaboradores que tienen de 1-3 anios en la empresa el monto que se toma en
    considereacion es el de aguinaldo anual

    Para los colaboradores que tienen mas de 3 anios se toma en cuenta la indemnizacion
    aproximada
"""

def calcular_antiguedad_laboral(FechaDeContratacion):
    # Supongamos que FechaDeContratacion ya es un objeto datetime.date
    fecha_actual = datetime.now().date()
    
    anos = fecha_actual.year - FechaDeContratacion.year
    meses = fecha_actual.month - FechaDeContratacion.month
    
    # Ajusta el número de años y meses si el mes actual es anterior al mes de contratación
    if meses < 0:
        anos -= 1
        meses += 12

    return anos, meses

def calcular_monto_acumulado_hasta_fecha_actual(FechaDeContratacion,SalarioMensual:Decimal) -> Decimal:
    
    FechaDeContratacion = str(FechaDeContratacion)
    fecha_actual = datetime.now()

    FechaDeContratacion = datetime.strptime(FechaDeContratacion, "%Y-%m-%d")

    anios_laborados = relativedelta(fecha_actual,FechaDeContratacion)
    anios_laborados = anios_laborados.years

    # calculo de meses transcurridos desde anio corriente
    mes_actual = fecha_actual.month
    meses_transcurridos = mes_actual - 1 

    if anios_laborados < 1:

        diferencia = relativedelta(fecha_actual,FechaDeContratacion)
        meses_exactos = diferencia.months + diferencia.years * 12

        dias_exactos = diferencia.days

        pago_meses = (SalarioMensual/12) * meses_exactos
        pago_dias = (SalarioMensual/12/30*dias_exactos)

        return (pago_meses+pago_dias).quantize(Decimal("0.000"), rounding=ROUND_DOWN)
    
    elif anios_laborados >= 3 and meses_transcurridos > 0: 

        valor_dia = Decimal(SalarioMensual)/Decimal(365/12)
        pago_despues_de_tres_anios = valor_dia * 20

        indemnizacion = SalarioMensual * 3 + (anios_laborados-3) * pago_despues_de_tres_anios

        return indemnizacion.quantize(Decimal("0.000"), rounding=ROUND_DOWN)
        #return indemnizacion

    elif anios_laborados >= 1 and anios_laborados <= 3:
        
        #liquidacion = SalarioMensual * anios_laborados
        return SalarioMensual

def calcular_interes(MontoAprobado: Decimal) -> Decimal:

    if  Decimal('0') < MontoAprobado <= Decimal('10000'):
        return Decimal('0.025')
    elif  Decimal('10001') < MontoAprobado <= Decimal('20000'):
        return Decimal('0.02')
    elif  Decimal('20001') < MontoAprobado <= Decimal('35999'):
        return Decimal('0.015')
    else:
        return Decimal('0.01')

"""
    validar_insersion_colaborador () nos ayuda a verificar si ya existen valores
    de cedulas, numeros telefonicos y correos electronicos ya almacenados en la bd,
    values = tipo tupla
    cedulas, numeros y correos de tipo lista
"""
def validar_insersion_colaborador(values, cedulas, numeros, correos) -> str:
    
    for cedula in cedulas:
        i = 0
        if values[0] in cedula:
            return "CEDULA"
        
        if i <= len(values):
            i+=1 

    for numero in numeros:
        i = 0
        if values[1] in numero:
            return "NUMERO"
        
        if i <= len(values):
            i+=1 

    for correo in correos:
        i = 0
        if values[2] in correo:
            return "EMAIL"

        if i <= len(values):
            i+=1 

def validar_insersion_admin(values, cedulas, numeros, correos, ids) -> str:
    
    for cedula in cedulas:
        i = 0
        if values[0] in cedula:
            return "CEDULA"
        
        if i <= len(values):
            i+=1 

    for numero in numeros:
        i = 0
        if values[1] in numero:
            return "NUMERO"
        
        if i <= len(values):
            i+=1 

    for correo in correos:
        i = 0
        if values[2] in correo:
            return "EMAIL"

        if i <= len(values):
            i+=1 
    
    for id in ids:
        
        i = 0

        if values[3] == id:
            return "ID"

        if i <= len(values):
            i+=1
