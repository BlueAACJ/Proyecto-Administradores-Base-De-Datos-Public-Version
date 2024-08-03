from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, Image
from reportlab.lib.styles import getSampleStyleSheet
from datetime import datetime

def reporteprestamo(file_name, loan_info, borrower_info, lender_info, payment_details,autor):
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

    # Título del reporte y fecha de generación
    title_text = "Reporte de Préstamo"
    report_date = datetime.now().strftime("%d/%m/%Y")
    generadordelreporte = autor
    title = f"{title_text}"
    content.append(Paragraph(title, styles["Title"]))
    content.append(Paragraph(f"Fecha de generación del reporte: {report_date} "))
    content.append(Paragraph(f"Reporte Generador por: {generadordelreporte} "))

    # Información del Colaborador (Prestamista)
    content.append(Paragraph("Información del Colaborador:", styles["Heading2"]))
    borrower_info_text = f"""
    Nombre: {borrower_info[0]['nombre']}<br/>
    Numero de Cedula: {borrower_info[0]['cedula']}<br/>
    Teléfono: {borrower_info[0]['telefono']}<br/>
    """
    content.append(Paragraph(borrower_info_text, styles["Normal"]))

    # Información del Administrador (Prestatario)
    content.append(Paragraph("Información del Administrador:", styles["Heading2"]))
    lender_info_text = f"""
    Nombre: {lender_info[0]['nombre']}<br/>
    Sucursal: {lender_info[0]['sucursal']}<br/>
    Teléfono: {lender_info[0]['telefono']}<br/>
    """
    content.append(Paragraph(lender_info_text, styles["Normal"]))

    # Detalles del Préstamo
    content.append(Paragraph("Detalles del Préstamo:", styles["Heading2"]))
    loan_details_text = f"""
    Id del Préstamo: {loan_info[0]['id']}
    &nbsp;&nbsp;&nbsp;&nbsp; Fecha de Aprobación: {loan_info[0]['fecha']}<br/>
    Capital: C${loan_info[0]['capital']}
    &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Tasa de Interés: {loan_info[0]['tasa']}%
    &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Total a Pagar: C${loan_info[0]['total']}<br/>
    Plazo de Pago: {loan_info[0]['plazo']} mes(es)
    &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Número de cuotas: {loan_info[0]['cuotas']}
    &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Estado de Préstamo: {loan_info[0]['estado']}
    """
    content.append(Paragraph(loan_details_text, styles["Normal"]))
    content.append(Spacer(1, 12))  # Espacio vertical

    # Detalles de los Pagos
    content.append(Paragraph("Detalles de Pago:", styles["Heading2"]))
    payment_data = [['Cuota', 'Fecha de Pago', 'Monto del Pago', 'Capital', 'Intereses', 'Saldo', 'Estado']]
    for payment in payment_details:
        payment_data.append([payment['cuota'], payment['fecha'], f"C${payment['monto']}", f"C${payment['capital']}", f"C${payment['intereses']}", f"C${payment['saldo']}",payment['estado']])
    content.append(create_table(payment_data))

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
