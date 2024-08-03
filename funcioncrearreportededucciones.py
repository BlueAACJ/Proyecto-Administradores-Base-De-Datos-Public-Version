from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, Image
from reportlab.lib.styles import getSampleStyleSheet
from datetime import datetime

def crearreportededucciones(file_name, admin_info, deducciones,Fecha):
    # Crear un lienzo con el tamaño de una página de carta (letter)
    doc = SimpleDocTemplate(file_name, pagesize=letter)

    # Estilos para el contenido del PDF
    styles = getSampleStyleSheet()

    # Contenido del PDF
    content = []

    # Añadir logo en la esquina superior derecha
    logo_path = "static\images\GrupoTalse.jpg"  # Ruta de la imagen del logo
    logo = Image(logo_path, width=75, height=40)  # Ajustar el tamaño de la imagen según sea necesario
    logo.hAlign = 'RIGHT'
    content.append(logo)

    # Título del reporte debajo del logo
    content.append(Paragraph("Reporte de Deducciones", styles["Title"]))
    report_date = datetime.now().strftime("%d/%m/%Y")
    content.append(Paragraph(f"Fecha de generación del reporte: {report_date} "))
    content.append(Paragraph(f"Fecha de Quincena Corespondiente: {Fecha} "))

    # Información del administrador con saltos de línea
    admin_info_text = f"""
    Información del Administrador:<br/>
    Nombre: {admin_info[0][2]} {admin_info[0][3]}<br/>
    Sucursal: {admin_info[0][3]}<br/>
    Numero de Cedula: {admin_info[0][1]}<br/>
    """
    content.append(Paragraph(admin_info_text, styles["Normal"]))

    # Agregar espacio en blanco
    content.append(Spacer(1, 12))  # Espacio de 12 puntos

    # Lista de deducciones
    deductions_data = [['Número de cuota', 'Nombre del Colaborador', 'Monto de Pago']]

    # Total a deducir
    Total = 0

    for deduction in deducciones:
        deductions_data.append([deduction['numero_cuota'], deduction['nombre_colaborador'], f"C${deduction['monto_pago']}"])
        Total += deduction['monto_pago']
    
    # Agregar linea Final al documento 
    deductions_data.append(["Total: ","",f"C${Total}"])

    # Agregar título de la tabla
    content.append(Paragraph("Lista de deducciones:", styles["Heading2"]))

    # Agregar tabla de deducciones
    content.append(create_table(deductions_data))

    # Construir el PDF
    doc.build(content)

def create_table(data):
    # Crear tabla con los datos proporcionados
    table = Table(data)
    # Añadir estilo a la tabla
    table.setStyle([
        ('GRID', (0, 0), (-1, -1), 1, 'black'),  # Añadir bordes a la tabla
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),  # Alinear el contenido al centro
    ])
    return table
