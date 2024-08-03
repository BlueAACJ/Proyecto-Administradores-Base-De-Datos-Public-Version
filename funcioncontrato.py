from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from datetime import datetime
from reportlab.lib.styles import ParagraphStyle

def crear_contrato_prestamo(file_name, prestamo_info, solicitud_info, unidadnegocio, antiguedad, debe, colaborador_info):
    doc = SimpleDocTemplate(file_name, pagesize=letter)
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='Justify', alignment=4))

    # Contenido del contrato
    content = []
    
    # Logo
    logo_path = "static/images/GrupoTalse.jpg"
    logo = Image(logo_path, width=75, height=40)
    logo.hAlign = 'RIGHT'
    content.append(logo)
    content.append(Spacer(1, 12))

    # Título y fecha
    title = "Solicitud de Credito"
    content.append(Paragraph(title, styles["Title"]))
    content.append(Spacer(1, 12))
    # Estilo personalizado para el párrafo de la fecha
    right_aligned_style = ParagraphStyle(
        name='RightAligned',
        alignment=2  # 2 indica alineación a la derecha
    )
    # Añadir la fecha de descarga del contrato
    fecha_actual = datetime.now().strftime("%Y-%m-%d")
    content.append(Paragraph(f"Fecha Generacion de Contrato: {fecha_actual}", right_aligned_style))
    content.append(Spacer(1, 16))

    # Diccionario para mapear las letras a las palabras correspondientes
    tipo_contrato_map = {
        'D': 'Determinado',
        'I': 'Indeterminado'
    }

    # Información del préstamo
    loan_details = f"""
    Fecha de Solicitud: {solicitud_info['fecha']}<br/>
    Unidad de Negocio: {unidadnegocio}<br/>
    Nombre del solicitante: {colaborador_info['nombre']}<br/>
    Cantidad solicitada: C$ {solicitud_info['cantidad']}<br/>
    Plazo de pago: {solicitud_info['plazo']} Meses<br/>
    Motivo de Solicitud: {solicitud_info['motivo']}<br/>
    Antigüedad Laboral: {antiguedad}<br/>
    Teléfono: {colaborador_info['telefono']}<br/>
    Estatus Laboral: {tipo_contrato_map.get(colaborador_info['estatus'], 'Desconocido')}<br/>
    """

    # Separar las filas del contenido
    loan_details_lines = loan_details.split('<br/>')

    # Añadir cada línea separada al contenido
    for line in loan_details_lines:
        content.append(Paragraph(line, styles["Justify"]))
        content.append(Spacer(1, 8))  # Agregar un pequeño espacio vertical entre cada línea

    # Firmas
    content.append(Spacer(1, 15))

    # Definir un nuevo estilo para la línea de firma de Recursos Humanos con negrita
    firma_rh_style = ParagraphStyle(
    name='FirmaRHStyle',
    fontName='Helvetica-Bold',  # Usar fuente en negrita
    fontSize=10,  # Tamaño de fuente
    leading=12,  # Espacio entre líneas
    alignment=0  # Alineación a la izquierda
    )

    # Agregar el texto de las firmas
    texto_firma = """
    Firma del Solicitante: _________________________<br/>
    """
    content.append(Paragraph(texto_firma, firma_rh_style))
    content.append(Spacer(1, 12))

    # Uso exclusivo de Recursos Humanos
    content.append(Paragraph("Uso exclusivo de Recursos Humanos:", styles["Heading2"]))

    # Uso exclusivo de Recursos Humanos
    content.append(Paragraph("Prestamo Acordado:", styles["Heading2"]))
    #Deudas actuales con Petunia: {debe}<br/>
    rh_details = f"""
    Plazo de pago aprobado: {prestamo_info['plazoPagoAprobado']} Meses<br/>
    Cantidad Aprobada: C$ {prestamo_info['capital']}<br/>
    Intereses: {prestamo_info['Intereses'] * 100 } %<br/>
    Tipo de Interes: Tasa de Interés Fija <br/>
    """
    # Separar las filas del contenido
    recursoHumano = rh_details.split('<br/>')

    # Añadir cada línea separada al contenido
    for line in recursoHumano:
        content.append(Paragraph(line, styles["Justify"]))
        content.append(Spacer(1, 8))

    # Firma de Recursos Humanos
    content.append(Spacer(1, 12))
    
    # Texto de la firma de Recursos Humanos
    firma_rh = "Firma de Responsable de Recursos Humanos: _________________________"

    # Agregar el texto de la firma de Recursos Humanos con el nuevo estilo
    content.append(Paragraph(firma_rh, firma_rh_style))

    # Construcción del PDF
    doc.build(content)



