use grupotalse;
-- restar un año a todas las fechas de solicitud en SolicitudesPrestamos
UPDATE SolicitudesPrestamos
SET FechaDeSolicitud = DATE_SUB(FechaDeSolicitud, INTERVAL 1 YEAR)
WHERE IdSolicitudesPrestamos > 0; 

-- restar un año a todas las fechas de un préstamo
UPDATE Prestamos
SET FechaDeAprobacion = DATE_SUB(FechaDeAprobacion, INTERVAL 1 YEAR)
WHERE IdPrestamo > 0; -- Utiliza una condición adecuada basada en la columna clave;

-- restar un año a todas las fechas de pago en RegistroPagos
UPDATE RegistroPagos
SET FechaDePago = DATE_SUB(FechaDePago, INTERVAL 1 YEAR)
WHERE IdRegistroPago > 0;

-- actualización del estado de cuota en RegistroPagos para cuotas con fecha anterior a la actual
UPDATE RegistroPagos
SET EstadoCuota = 'C'
WHERE FechaDePago < CURDATE() and IdRegistroPago > 0;

-- actualizar estado de prestamo a C si ya se cancelo 
UPDATE Prestamos 
SET EstadoPrestamo = 'C'
WHERE IdPrestamo = 2;

-- actualizar estado crediticio de los colaboradores
UPDATE colaboradores 
SET EstadoCrediticio = '0'
WHERE idcolaborador = 5;

-------------------------------------------------------------------------------------------------------- 
-- un prestamo en especifico 
UPDATE SolicitudesPrestamos
SET FechaDeSolicitud = DATE_SUB(FechaDeSolicitud, INTERVAL 1 YEAR)
WHERE IdSolicitudesPrestamos = 4;

UPDATE Prestamos
SET FechaDeAprobacion = DATE_SUB(FechaDeAprobacion, INTERVAL 1 YEAR)
WHERE IdPrestamo = 4;

UPDATE RegistroPagos
SET FechaDePago = DATE_SUB(FechaDePago, INTERVAL 1 year)
WHERE IdPrestamo = 4;
