-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
use grupotalse;
-- Este procedimiento obtiene todas las solicitudes aceptas que estan asociadas al administrador
DELIMITER //
CREATE PROCEDURE SolicitudesAceptadas(
    IN IdAdmin INT -- Parámetro de entrada: ID del administrador para filtrar las solicitudes aceptadas por este administrador
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos aceptadas, junto con los detalles de los colaboradores y préstamos
    SELECT 
        p.FechaDeAprobacion,        -- Fecha en que se aprobó el préstamo
        c.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,       -- Nombres del colaborador
        c.ApellidosColaborador,     -- Apellidos del colaborador
        pr.Capital,                 -- Capital del préstamo aprobado
        pr.PlazoDePago_Meses,       -- Plazo de pago del préstamo en meses
        pr.Cuotas                   -- Número de cuotas del préstamo
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador -- Relación con la tabla de administradores
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador     -- Relación con la tabla de colaboradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con la tabla de préstamos
    JOIN 
        (SELECT IdPrestamo, FechaDeAprobacion FROM Prestamos) p ON pr.IdPrestamo = p.IdPrestamo -- Relación para obtener la fecha de aprobación del préstamo
    WHERE 
        sp.EstadoSolicitud = 'A'    -- Filtro para seleccionar solo las solicitudes en estado "A" (aceptadas)
    AND 
        a.IdAdministrador = IdAdmin; -- Filtro para seleccionar solicitudes gestionadas por el administrador específico
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento obtiene todas las solicitudes Denegadas que estan asociadas al administrador
DELIMITER //
CREATE PROCEDURE SolicitudesDenegadas(
    IN IdAdmin INT -- Parámetro de entrada: ID del administrador para filtrar las solicitudes denegadas por este administrador
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos denegadas, junto con los detalles de los colaboradores
    SELECT 
        SP.FechaDeSolicitud,        -- Fecha en que se realizó la solicitud de préstamo
        C.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        C.NombresColaborador,       -- Nombres del colaborador
        C.ApellidosColaborador,     -- Apellidos del colaborador
        SP.MontoSolicitado,         -- Monto solicitado en el préstamo
        SP.PlazoDePago              -- Plazo de pago del préstamo solicitado
    FROM
        Colaboradores C             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos SP ON C.IdColaborador = SP.IdColaborador -- Relación con la tabla de solicitudes de préstamos
    JOIN
        Administrador a ON SP.IdAdministrador = a.IdAdministrador -- Relación con la tabla de administradores
    WHERE
        SP.EstadoSolicitud = 'D'    -- Filtro para seleccionar solo las solicitudes en estado "D" (denegadas)
    AND 
        a.IdAdministrador = IdAdmin; -- Filtro para seleccionar solicitudes gestionadas por el administrador específico
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento obtiene todas las solicitudes en espera, sirve para poder mostrar las solicitudes y poder aceptarlas o denegarlas
DELIMITER //
CREATE PROCEDURE SolicitudesEspera(
    IN IdAdmin INT -- Parámetro de entrada: ID del administrador para filtrar las solicitudes en espera que maneja el administrador
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos en espera, junto con los detalles de los colaboradores
    SELECT 
        sp.FechaDeSolicitud,         -- Fecha en que se realizó la solicitud de préstamo
        c.CedulaColaborador,         -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        sp.MontoSolicitado,          -- Monto solicitado en el préstamo
        sp.PlazoDePago,              -- Plazo de pago del préstamo
        sp.IdColaborador,            -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con la tabla de colaboradores
    JOIN
        Administrador a ON sp.IdAdministrador = a.IdAdministrador -- Relación con la tabla de administradores
    WHERE 
        sp.EstadoSolicitud = 'E'     -- Filtro para seleccionar solo las solicitudes en estado "E" (en espera)
    AND
        a.IdAdministrador = IdAdmin; -- Filtro para seleccionar solicitudes gestionadas por el administrador específico
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento obtiene todos los prestamos activos asociados al admin 
DELIMITER //
CREATE PROCEDURE PrestamosActivos(
    IN IdAdmin INT -- Parámetro de entrada: ID del administrador para filtrar los préstamos
)
BEGIN
    -- Selección de los datos relevantes sobre los préstamos activos y sus colaboradores asociados
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha de aprobación del préstamo
        c.CedulaColaborador,         -- Cédula del colaborador
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (se espera que sea 'A' para activos)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,              -- ID del colaborador
        sp.IdSolicitudesPrestamos
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    WHERE 
        pr.EstadoPrestamo = 'A'      -- Filtro para seleccionar solo préstamos activos
    AND 
        a.IdAdministrador = IdAdmin; -- Filtro para seleccionar préstamos asociados al administrador específico
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimientos muestra todos los prestamos cancelados asociados al administrador 
DELIMITER //
CREATE PROCEDURE PrestamosCancelados(
    IN IdAdmin INT -- Parámetro de entrada: ID del administrador para filtrar los préstamos cancelados por este administrador
)
BEGIN
    -- Consulta para obtener la información de los préstamos cancelados, junto con los detalles de los colaboradores
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha en que se aprobó el préstamo
        c.CedulaColaborador,         -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (esperado que sea 'C' para cancelados)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,              -- ID del colaborador
        sp.IdSolicitudesPrestamos
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    WHERE 
        pr.EstadoPrestamo = 'C'      -- Filtro para seleccionar solo préstamos cancelados
    AND 
        a.IdAdministrador = IdAdmin; -- Filtro para seleccionar préstamos gestionados por el administrador específico
END//
DELIMITER ;


-- Este procedimiento ingresa un nuevo colaborador a la tabla Colaboradores 
DELIMITER //
CREATE PROCEDURE InsertarColaborador(
    IN p_FechaContratacion DATE,           -- Fecha de contratación del colaborador
    IN p_CedulaColaborador VARCHAR(16),    -- Cédula del colaborador
    IN p_NombresColaborador VARCHAR(50),   -- Nombres del colaborador
    IN p_ApellidosColaborador VARCHAR(50), -- Apellidos del colaborador
    IN p_SalarioColaborador DECIMAL(15,2), -- Salario del colaborador
    IN p_TipoDeContrato CHAR(1),           -- Tipo de contrato del colaborador
    IN p_EstadoCrediticio CHAR(1),         -- Estado crediticio del colaborador
    IN p_CorreoColaborador VARCHAR(50),    -- Correo electrónico del colaborador
    IN p_NumeroTelefonoColaborador VARCHAR(10), -- Número de teléfono del colaborador
    IN p_Contrasenia CHAR(102),            -- Contraseña del colaborador
    IN p_IdSucursal INT,                   -- ID de la sucursal del colaborador
    IN p_EstadoColaborador CHAR(1)         -- Estado del colaborador
)
BEGIN
    -- Inserta un nuevo colaborador en la tabla Colaboradores con los datos proporcionados
    INSERT INTO Colaboradores (
        FechaContratacion,                 -- Fecha de contratación
        CedulaColaborador,                 -- Cédula del colaborador
        NombresColaborador,                -- Nombres del colaborador
        ApellidosColaborador,              -- Apellidos del colaborador
        SalarioColaborador,                -- Salario del colaborador
        TipoDeContrato,                    -- Tipo de contrato
        EstadoCrediticio,                  -- Estado crediticio
        CorreoColaborador,                 -- Correo electrónico
        NumeroTelefonoColaborador,         -- Número de teléfono
        Contrasenia,                       -- Contraseña
        IdSucursal,                        -- ID de la sucursal
        EstadoColaborador                  -- Estado del colaborador
    )
    VALUES (
        p_FechaContratacion,               -- Valor del parámetro Fecha de contratación
        p_CedulaColaborador,               -- Valor del parámetro Cédula del colaborador
        p_NombresColaborador,              -- Valor del parámetro Nombres del colaborador
        p_ApellidosColaborador,            -- Valor del parámetro Apellidos del colaborador
        p_SalarioColaborador,              -- Valor del parámetro Salario del colaborador
        p_TipoDeContrato,                  -- Valor del parámetro Tipo de contrato
        p_EstadoCrediticio,                -- Valor del parámetro Estado crediticio
        p_CorreoColaborador,               -- Valor del parámetro Correo electrónico
        p_NumeroTelefonoColaborador,       -- Valor del parámetro Número de teléfono
        p_Contrasenia,                     -- Valor del parámetro Contraseña
        p_IdSucursal,                      -- Valor del parámetro ID de la sucursal
        p_EstadoColaborador                -- Valor del parámetro Estado del colaborador
    );
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento sirve para modificar datos del colaborador
DELIMITER //
CREATE PROCEDURE ModificarColaborador(
    IN colaborador_id INT,               -- ID del colaborador a modificar
    IN nuevo_cedula VARCHAR(16),         -- Nueva cédula del colaborador
    IN nuevo_nombre VARCHAR(50),         -- Nuevo nombre del colaborador
    IN nuevo_apellido VARCHAR(50),       -- Nuevo apellido del colaborador
    IN nuevo_salario DECIMAL(15,2),      -- Nuevo salario del colaborador
    IN nuevo_tipo_contrato CHAR(1),      -- Nuevo tipo de contrato del colaborador
    IN nuevo_correo VARCHAR(50),         -- Nuevo correo del colaborador
    IN nuevo_telefono VARCHAR(10)        -- Nuevo número de teléfono del colaborador
)
BEGIN
    -- Actualiza los datos del colaborador con el ID especificado en la tabla Colaboradores
    UPDATE Colaboradores SET 
        CedulaColaborador = nuevo_cedula,         -- Actualiza la cédula del colaborador
        NombresColaborador = nuevo_nombre,        -- Actualiza el nombre del colaborador
        ApellidosColaborador = nuevo_apellido,    -- Actualiza el apellido del colaborador
        SalarioColaborador = nuevo_salario,       -- Actualiza el salario del colaborador
        TipoDeContrato = nuevo_tipo_contrato,     -- Actualiza el tipo de contrato del colaborador
        CorreoColaborador = nuevo_correo,         -- Actualiza el correo del colaborador
        NumeroTelefonoColaborador = nuevo_telefono -- Actualiza el número de teléfono del colaborador
    WHERE IdColaborador = colaborador_id;         -- Condición para identificar el colaborador a modificar

END //
DELIMITER ;

-- Mostrar los datos de un colaborador en especifico
DELIMITER //
CREATE PROCEDURE MostrarUnColaborador(
    IN id INT -- ID del colaborador a mostrar
)
BEGIN
    -- Selecciona todos los campos del colaborador con el ID especificado en la tabla Colaboradores
    SELECT * FROM Colaboradores WHERE IdColaborador = id; -- Condición para identificar el colaborador a mostrar
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Mostrar todos los colaborador de la sucursal asociados al administrador
DELIMITER //
CREATE PROCEDURE MostrarColaboradoresPorSucursal(
    IN p_IdAdmin INT -- ID del administrador para filtrar los colaboradores por su sucursal
)
BEGIN
    DECLARE v_AdminId INT;
    
    -- Verificar si el ID del administrador proporcionado es válido
    SELECT IdAdministrador INTO v_AdminId
    FROM Administrador
    WHERE IdAdministrador = p_IdAdmin;
    
    -- Si el ID del administrador proporcionado es válido, mostrar los colaboradores asociados a ese administrador
    IF v_AdminId IS NOT NULL THEN
        SELECT c.*
        FROM 
            Colaboradores c
        JOIN
            Sucursales s ON c.IdSucursal = s.IdSucursal
        JOIN
            Administrador a ON s.IdSucursal = a.IdSucursal
        WHERE a.IdAdministrador = v_AdminId;
    END IF;
END//
DELIMITER ;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento muestra todos los datos de un administrador
DELIMITER //
CREATE PROCEDURE MostarDatosAdmin(
    IN Id INT -- ID del administrador a mostrar
)
BEGIN
    -- Selecciona todos los campos del administrador con el ID especificado en la tabla Administrador
    SELECT * FROM Administrador WHERE IdAdministrador = Id; -- Condición para identificar el administrador a mostrar
END //
DELIMITER ;

-- Este procedimiento verifica si un colaborador tiene una solicitud en espera o un prestamo activo
DELIMITER //

CREATE PROCEDURE ValidarSolicitudPrestamoYEstado(
    IN colaborador_id INT,  -- ID del colaborador para validar su solicitud de préstamo y estado de préstamo activo
    OUT resultado INT       -- Variable de salida para indicar el resultado de la validación
)
BEGIN
    -- Inicializar el resultado como 0
    SET resultado = 0;

    -- Verificar si el colaborador tiene una solicitud de préstamo pendiente
    IF EXISTS (
        SELECT 1
        FROM SolicitudesPrestamos
        WHERE IdColaborador = colaborador_id AND EstadoSolicitud = 'E'
    ) THEN
        -- Si hay una solicitud pendiente, establecer el resultado como 1
        SET resultado = 1;
    ELSE
        -- Verificar si el colaborador tiene un préstamo activo
        IF EXISTS (
            SELECT 1
            FROM Prestamos
            WHERE IdSolicitudesPrestamos IN (
                SELECT IdSolicitudesPrestamos
                FROM SolicitudesPrestamos
                WHERE IdColaborador = colaborador_id
            ) AND EstadoPrestamo = 'A'
        ) THEN
            -- Si hay un préstamo activo, establecer el resultado como 2
            SET resultado = 2;
        END IF;
    END IF;
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento muestra el historial de solicitudes del colaborador
DELIMITER //
CREATE PROCEDURE HistorialSolicitudesColaborador (
    IN p_CedulaColaborador VARCHAR(16) -- Cédula del colaborador para obtener su historial de solicitudes
)
BEGIN
    -- Este procedimiento recupera y muestra el historial de solicitudes de préstamo asociadas a un colaborador específico.

    SELECT 
        sp.FechaDeSolicitud,    -- Fecha de la solicitud de préstamo
        sp.MontoSolicitado,     -- Monto solicitado en la solicitud
        sp.PlazoDePago,         -- Plazo de pago en la solicitud
        sp.MotivoPrestamo,      -- Motivo del préstamo en la solicitud
        sp.EstadoSolicitud,      -- Estado de la solicitud de préstamo
        sp.IdSolicitudesPrestamos
    FROM 
        SolicitudesPrestamos sp -- Tabla de solicitudes de préstamo
    INNER JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con la tabla de colaboradores
    WHERE 
        c.CedulaColaborador = p_CedulaColaborador; -- Filtrar por la cédula del colaborador proporcionada
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento muestra el historial de prestamos del colaborador
DELIMITER //
CREATE PROCEDURE HistorialPrestamosColaborador (
    IN p_CedulaColaborador VARCHAR(16) -- Cédula del colaborador para obtener su historial de préstamos
)
BEGIN
    -- Este procedimiento recupera y muestra el historial de préstamos asociados a un colaborador específico.

    SELECT 
        p.FechaDeAprobacion,     -- Fecha de aprobación del préstamo
        p.Capital,               -- Capital del préstamo
        p.Intereses,             -- Intereses del préstamo
        p.Cuotas,                -- Cuotas del préstamo
        p.PlazoDePago_Meses,     -- Plazo de pago en meses del préstamo
        p.EstadoPrestamo,         -- Estado del préstamo
        sp.IdSolicitudesPrestamos    
    FROM 
        Prestamos p              -- Tabla de préstamos
    INNER JOIN 
        SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos -- Relación con solicitudes de préstamos
    INNER JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con colaboradores
    WHERE 
        c.CedulaColaborador = p_CedulaColaborador; -- Filtrar por la cédula del colaborador proporcionada
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento obtiene informacion del prestamo del colaborador 
DELIMITER //
CREATE PROCEDURE InfoDetallePrestamoCol(
    IN IdSolicitud INT,       -- ID de la solicitud de préstam
    IN cedula VARCHAR(16)     -- Cédula del colaborador
)
BEGIN
    -- Este procedimiento devuelve información detallada sobre un préstamo asociado a una solicitud y un colaborador específicos.
    SELECT 
        pr.IdPrestamo,                                       -- ID del préstamo
        CONCAT(c.NombresColaborador, ' ', c.ApellidosColaborador) AS NombreCompleto, -- Nombre completo del colaborador
        pr.PlazoDePago_Meses,                                -- Plazo de pago en meses
        s.nombreDeSucursal AS NombreSucursal,                -- Nombre de la sucursal
        s.direccionSucursal AS DireccionSucursal,            -- Dirección de la sucursal
        pr.Capital,                                          -- Capital del préstamo
        pr.Intereses,                                        -- Intereses del préstamo
        pr.Cuotas,                                           -- Cuotas del préstamo
        pr.EstadoPrestamo,                                    -- Estado del préstamo
        sp.IdSolicitudesPrestamos,
        c.IdColaborador                                 
    FROM 
        Colaboradores c                                      -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        Administrador a ON pr.IdAdministrador = a.IdAdministrador -- Relación con administradores
    JOIN 
        Sucursales s ON a.IdSucursal = s.IdSucursal          -- Relación con sucursales
    WHERE 
        c.CedulaColaborador = cedula                        -- Filtrar por la cédula del colaborador
    AND 
        sp.IdSolicitudesPrestamos = IdSolicitud;            -- Filtrar por el ID de la solicitud de préstamo
END //
DELIMITER ;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento muestra las cuotas de un prestamo en especifico 
DELIMITER //
CREATE PROCEDURE MostrarRegistroPagoColaborador (
    IN id_Solicitud INT,                -- ID de la solicitud de préstamo
    IN p_CedulaColaborador VARCHAR(16)  -- Cédula del colaborador
)
BEGIN
    -- Este procedimiento muestra el registro de pagos asociado a una solicitud de préstamo y un colaborador específicos.
    SELECT 
        rp.IdRegistroPago AS IdRegistroPago,          -- ID del registro de pago
        rp.NumeroDeCuota AS NumeroDeCuota,            -- Número de la cuota
        rp.FechaDePago AS FechaDePago,                -- Fecha de pago
        rp.EstadoCuota AS EstadoCuota,                -- Estado de la cuota
        p.FechaDeAprobacion AS FechaDeAprobacion,     -- Fecha de aprobación del préstamo
        p.PlazoDePago_Meses AS PlazoDePago,           -- Plazo de pago en meses del préstamo
        p.Capital AS Capital,                         -- Capital del préstamo
        p.Intereses AS Intereses                      -- Intereses del préstamo
    FROM 
        RegistroPagos rp                              -- Tabla de registro de pagos
    JOIN 
        Prestamos p ON rp.IdPrestamo = p.IdPrestamo   -- Relación con préstamos
    JOIN 
        SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos -- Relación con solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con colaboradores
    WHERE 
        c.CedulaColaborador = p_CedulaColaborador     -- Filtrar por la cédula del colaborador
    AND 
        sp.IdSolicitudesPrestamos = id_Solicitud;      -- Filtrar por el ID de la solicitud de préstamo
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento cambia el estado de un colaborador de "A" Activo a "D" Despedido
DELIMITER //
CREATE PROCEDURE CambiarEstadoColaborador(
    IN p_IdColaborador INT
)
BEGIN
    -- Verificar si el colaborador existe
    IF EXISTS (SELECT 1 FROM Colaboradores WHERE IdColaborador = p_IdColaborador) THEN
        -- Actualizar el estado del colaborador a "D" (Despedido)
        UPDATE Colaboradores
        SET EstadoColaborador = 'D'
        WHERE IdColaborador = p_IdColaborador;
    END IF;
END //
DELIMITER ;

-- Este procedimiento muestra todas las solicitudes pendientes asociadas a un administrador 
DELIMITER //
CREATE PROCEDURE MostrarSolicitudesPendientes(
    IN admin_id INT -- ID del administrador para filtrar las solicitudes pendientes
)
BEGIN
    -- Este procedimiento muestra las solicitudes de préstamo pendientes asociadas a un administrador específico.
    SELECT s.*                              -- Selecciona todos los campos de la tabla de solicitudes de préstamo
    FROM SolicitudesPrestamos s             -- Tabla de solicitudes de préstamo
    JOIN Administrador a ON s.IdAdministrador = a.IdAdministrador -- Relación con la tabla de administradores
    WHERE s.EstadoSolicitud = 'E'           -- Filtra por solicitudes en estado pendiente
    AND s.IdAdministrador = admin_id;       -- Filtra por el ID del administrador proporcionado
END//
DELIMITER ;

-- Este procedimiento muestra el estado de una solicitud
DELIMITER //
CREATE PROCEDURE NotificarEstadoSolicitud(
    IN solicitud_id INT -- ID de la solicitud para la cual se notificará el estado
)
BEGIN
    -- Este procedimiento obtiene y devuelve el estado de una solicitud de préstamo.

    DECLARE colaborador_id INT;         -- Variable para almacenar el ID del colaborador asociado a la solicitud
    DECLARE estado_solicitud CHAR(1);   -- Variable para almacenar el estado de la solicitud

    -- Obtener el ID del colaborador asociado a la solicitud y su estado
    SELECT IdColaborador, EstadoSolicitud INTO colaborador_id, estado_solicitud
    FROM SolicitudesPrestamos
    WHERE IdSolicitudesPrestamos = solicitud_id;

    -- Devolver el estado de la solicitud
    SELECT estado_solicitud AS 'Estado';
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento muestra las fechas y estado de cuotas de un prestamos asociado a un colaborador
DELIMITER //
CREATE PROCEDURE MostrarFechasCuotas(
    IN colaborador_id INT -- ID del colaborador para filtrar las fechas y estados de las cuotas
)
BEGIN
    -- Este procedimiento muestra las fechas de pago y estados de las cuotas asociadas a un colaborador específico.
    SELECT rp.FechaDePago, rp.EstadoCuota
    FROM RegistroPagos rp
    JOIN Prestamos p ON rp.IdPrestamo = p.IdPrestamo
    JOIN SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
    JOIN Colaboradores c ON sp.IdColaborador = c.IdColaborador
    WHERE c.IdColaborador = colaborador_id;
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estas vistas muestra las cuotas a pagar de las quincenas del mes
CREATE VIEW CuotasMediadoDeMes AS
-- Esta vista muestra las cuotas que se pagan entre los días 13 y 17 de cada mes y tienen estado 'Pagado'.
SELECT *
FROM RegistroPagos
WHERE (DAY(FechaDePago) BETWEEN 13 AND 17) -- Filtrar días entre el 13 y el 17 de cada mes
    AND EstadoCuota = 'P'; -- Filtrar por cuotas que están pagadas

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW CuotasFinalDeMes AS
-- Esta vista muestra las cuotas que se pagan a finales de mes o a principios del siguiente mes y tienen estado 'Pagado'.
SELECT *
FROM RegistroPagos
WHERE (DAY(FechaDePago) >= 28 OR DAY(FechaDePago) <= 2) -- Filtrar los días finales del mes o los primeros días del siguiente mes
    AND EstadoCuota = 'P'; -- Filtrar por cuotas que están pagadas

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procemiento mostrustra la cuotas de la quincena que se deben pagar
DELIMITER //

CREATE PROCEDURE ObtenerCuotasPorPagar (
    IN p_IdAdministrador INT -- Parámetro de entrada: ID del administrador para filtrar las cuotas por pagar
)
BEGIN
    -- Este procedimiento devuelve las cuotas pendientes de pago para el mes actual, considerando el día actual del mes.

    DECLARE diaActual INT;           -- Variable para almacenar el día actual del mes
    DECLARE diaFinalMes INT;         -- Variable para almacenar el último día del mes actual
    DECLARE mesActual INT;           -- Variable para almacenar el mes actual
    DECLARE anioActual INT;          -- Variable para almacenar el año actual

    -- Obtener el día actual, el último día del mes actual, el mes actual y el año actual
    SET diaActual = DAY(CURDATE());
    SET diaFinalMes = DAY(LAST_DAY(CURDATE()));
    SET mesActual = MONTH(CURDATE());
    SET anioActual = YEAR(CURDATE());

    -- Seleccionar las cuotas pendientes de pago para el mes actual, considerando el día actual del mes
    SELECT
		sp.IdSolicitudesPrestamos,
        rp.IdRegistroPago,                         -- ID del registro de pago
        rp.FechaDePago,                            -- Fecha de pago de la cuota
        rp.NumeroDeCuota,                          -- Número de la cuota
        c.CedulaColaborador,                       -- Cédula del colaborador
        c.NombresColaborador,                      -- Nombres del colaborador
        c.ApellidosColaborador,                    -- Apellidos del colaborador
        rp.EstadoCuota,                            -- Estado de la cuota (pendiente, pagada, etc.)
        p.IdPrestamo,                              -- ID del préstamo asociado a la cuota
        p.PlazoDePago_Meses,                       -- Plazo de pago en meses del préstamo
        p.Capital,                                 -- Capital del préstamo
        p.Intereses                                -- Intereses del préstamo
    FROM 
        Colaboradores c                             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        RegistroPagos rp ON p.IdPrestamo = rp.IdPrestamo -- Relación con registros de pagos
    WHERE 
        p.IdAdministrador = p_IdAdministrador          -- Filtrar por el ID del administrador
        AND rp.EstadoCuota = 'P'                       -- Filtrar por cuotas pendientes de pago
        AND MONTH(rp.FechaDePago) = mesActual          -- Filtrar por el mes actual
        AND YEAR(rp.FechaDePago) = anioActual          -- Filtrar por el año actual
        AND (
            (diaActual <= 15 AND DAY(rp.FechaDePago) BETWEEN 13 AND 15) OR -- Si es la primera quincena del mes
            (diaActual > 15 AND DAY(rp.FechaDePago) BETWEEN diaFinalMes - 2 AND diaFinalMes) -- Si es la segunda quincena del mes
        ); 
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento actualiza las coutas automaticamente
DELIMITER //

CREATE PROCEDURE ActualizarEstadoCuotasAutomatico(
    IN p_Fecha DATE -- Fecha actual para la cual se realizará la actualización automática
)
BEGIN
    DECLARE lastDayOfMonth DATE;         -- Variable para almacenar el último día del mes actual
    DECLARE firstDayNextMonth DATE;      -- Variable para almacenar el primer día del mes siguiente
    DECLARE actualizacion DATE;          -- Variable para almacenar la fecha de actualización

    -- Calcular el último día del mes y el primer día del siguiente mes
    SET lastDayOfMonth = LAST_DAY(p_Fecha);
    SET firstDayNextMonth = DATE_ADD(lastDayOfMonth, INTERVAL 1 DAY);

    -- Actualizar cuotas que caen entre el 13 y el 15 del mes
    IF DAY(p_Fecha) = 16 THEN
        UPDATE RegistroPagos
        SET EstadoCuota = 'C' -- Cambiar el estado de las cuotas a "Completado"
        WHERE FechaDePago BETWEEN DATE_FORMAT(DATE_SUB(p_Fecha, INTERVAL 1 DAY), '%Y-%m-13') AND DATE_FORMAT(DATE_SUB(p_Fecha, INTERVAL 1 DAY), '%Y-%m-15');
    END IF;

    -- Actualizar cuotas que caen el último día del mes
    IF p_Fecha = firstDayNextMonth THEN
        UPDATE RegistroPagos
        SET EstadoCuota = 'C' -- Cambiar el estado de las cuotas a "Completado"
        WHERE FechaDePago = lastDayOfMonth;
    END IF;

END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento obtiene la cantidad de cuotas pendientes se usa en la ruta /opciones_inactividad_colaborador
DELIMITER //
CREATE PROCEDURE ObtenerPagosPendientesPorIdColaborador(
    IN idColaboradorParam INT,    -- Parámetro de entrada: ID del colaborador
    OUT cantidadPagosPendientes INT -- Parámetro de salida: cantidad de pagos pendientes
)
BEGIN
    -- Contar la cantidad de registros de pagos pendientes para el colaborador
    SELECT COUNT(*)
    INTO cantidadPagosPendientes
    FROM RegistroPagos rp
    INNER JOIN Prestamos p ON rp.IdPrestamo = p.IdPrestamo
    INNER JOIN SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
    WHERE sp.IdColaborador = idColaboradorParam -- Filtrar por el ID del colaborador
    AND rp.EstadoCuota = 'P'; -- Filtrar por pagos pendientes
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento nos ayuda a obtener el capita, interes y plazo de un prestamo
DELIMITER //
CREATE PROCEDURE ObtenerCapitalInteresYPlazoPago(IN id_colaborador INT)
BEGIN
    DECLARE id_prestamo INT;
    DECLARE id_solicitud_prestamo INT;
    DECLARE capital DECIMAL(15,2);
    DECLARE interes DECIMAL(15,3);
    DECLARE plazo_pago INT;
    
    SELECT p.IdPrestamo, p.IdSolicitudesPrestamos, p.Capital, p.Intereses, p.PlazoDePago_Meses
    INTO id_prestamo, id_solicitud_prestamo, capital, interes, plazo_pago
    FROM Prestamos p
    JOIN SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
    WHERE sp.IdColaborador = id_colaborador
    AND p.EstadoPrestamo = 'A';
    
    SELECT id_prestamo, id_solicitud_prestamo, capital, interes, plazo_pago;
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- obtener cantidad de cuotas deducidas, obtener la cantidad de cuotas pendientes
-- este procedimiento se usa en la ruta /opciones_inactividad_colaborador
DELIMITER //
CREATE PROCEDURE ObtenerPagosDeducidosPorIdColaborador(IN idColaboradorParam INT, OUT cantidadPagosDeducidos INT)
BEGIN
    -- Contar la cantidad de registros de pagos pendientes para el colaborador
    SELECT COUNT(*)
    INTO cantidadPagosDeducidos
    FROM RegistroPagos rp
    INNER JOIN Prestamos p ON rp.IdPrestamo = p.IdPrestamo
    INNER JOIN SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
    WHERE sp.IdColaborador = idColaboradorParam
    AND rp.EstadoCuota = 'D'; -- 'P' representa pagos deducidos
END//
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Este procedimiente obtiene los datos del administrador para generacion de reportes
DELIMITER //
CREATE PROCEDURE ObtenerInfoAdministradorConIdPrestamo (
    IN idPrestamo INT  -- ID del préstamo del cual se desea obtener la información del administrador asociado
)
BEGIN
    -- Seleccionar la información del administrador asociada al ID del préstamo proporcionado
    SELECT 
        a.IdAdministrador,                   -- ID del administrador
        a.CedulaAdministrador,               -- Cédula del administrador
        a.NombresAdministrador,              -- Nombres del administrador
        a.ApellidosAdministrador,            -- Apellidos del administrador
        a.CorreoAdministrador,               -- Correo electrónico del administrador
        a.NumeroTelefonoAdministrador,       -- Número de teléfono del administrador
        a.Usuario,                           -- Usuario del administrador
        a.Contrasenia,                       -- Contraseña del administrador
        a.EstadoAdministrador,               -- Estado del administrador (activo/inactivo)
        a.IdSucursal                         -- ID de la sucursal asociada al administrador
    FROM 
        Administrador a
    JOIN 
        Prestamos p ON a.IdAdministrador = p.IdAdministrador  -- Relación entre administrador y préstamo
    WHERE 
        p.IdPrestamo = idPrestamo;  -- Filtrar por el ID del préstamo proporcionado
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiente obtiene los datos del administrador para generacion de reportes
DELIMITER //
CREATE PROCEDURE ObtenerInfoColaboradorConIdPrestamo (
    IN idPrestamo INT  -- ID del préstamo del cual se desea obtener la información del colaborador asociado
)
BEGIN
    -- Seleccionar la información del colaborador asociada al ID del préstamo proporcionado
    SELECT 
        c.IdColaborador,                  -- ID del colaborador
        c.FechaContratacion,              -- Fecha de contratación del colaborador
        c.CedulaColaborador,              -- Cédula del colaborador
        c.NombresColaborador,             -- Nombres del colaborador
        c.ApellidosColaborador,           -- Apellidos del colaborador
        c.SalarioColaborador,             -- Salario del colaborador
        c.TipoDeContrato,                 -- Tipo de contrato del colaborador
        c.EstadoCrediticio,               -- Estado crediticio del colaborador
        c.CorreoColaborador,              -- Correo electrónico del colaborador
        c.NumeroTelefonoColaborador,      -- Número de teléfono del colaborador
        c.Contrasenia,                    -- Contraseña del colaborador
        c.IdSucursal,                     -- ID de la sucursal donde trabaja el colaborador
        c.EstadoColaborador               -- Estado del colaborador (activo/inactivo)
    FROM 
        Colaboradores c
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador  -- Relación entre colaborador y solicitud de préstamo
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos  -- Relación entre solicitud de préstamo y préstamo
    WHERE 
        p.IdPrestamo = idPrestamo;  -- Filtrar por el ID del préstamo proporcionado
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- este procedimiento obtiene los datos de los registros de pagos para generacion de reportes
DELIMITER //
CREATE PROCEDURE MostrarRegistroPagoColaboradorConIdPrestamo (
    IN id_Prestamo INT -- ID del préstamo para obtener los registros de pago del colaborador asociado
)
BEGIN
    -- Seleccionar la información de los registros de pago asociados al ID del préstamo proporcionado
    SELECT 
        rp.IdRegistroPago AS IdRegistroPago,        -- ID del registro de pago
        rp.NumeroDeCuota AS NumeroDeCuota,          -- Número de la cuota
        rp.FechaDePago AS FechaDePago,              -- Fecha de pago de la cuota
        rp.EstadoCuota AS EstadoCuota,              -- Estado de la cuota (pagado, pendiente, etc.)
        p.FechaDeAprobacion AS FechaDeAprobacion,   -- Fecha de aprobación del préstamo
        p.PlazoDePago_Meses AS PlazoDePago,         -- Plazo de pago del préstamo en meses
        p.Capital AS Capital,                       -- Capital del préstamo
        p.Intereses AS Intereses                    -- Intereses del préstamo
    FROM 
        RegistroPagos rp
    JOIN 
        Prestamos p ON rp.IdPrestamo = p.IdPrestamo              -- Relación entre registros de pago y préstamos
    JOIN 
        SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos -- Relación entre préstamos y solicitudes de préstamo
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador   -- Relación entre solicitudes de préstamo y colaboradores
    WHERE 
        p.IdPrestamo = id_Prestamo; -- Filtrar por el ID del préstamo proporcionado
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- -------------- ObtenerEstadoPrestamoMasReciente
-- utilizado para validar prestamo activo en el rol de colaborador
DELIMITER //

CREATE PROCEDURE ObtenerEstadoPrestamoMasReciente(
    IN id_colaborador INT
)
BEGIN
    -- Selecciona el estado del préstamo más reciente del colaborador
    SELECT p.EstadoPrestamo, sp.IdSolicitudesPrestamos
    FROM Prestamos p
    INNER JOIN SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
    WHERE sp.IdColaborador = id_colaborador
    ORDER BY p.FechaDeAprobacion DESC
    LIMIT 1;
END //
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Este procedimiento hace el calculo de las fechas de pago de un prestamo
DELIMITER //
CREATE PROCEDURE CalcularFechasDePago(
    IN prestamo_id INT -- Identificador del préstamo para el cual se calculan las fechas de pago
)
BEGIN
    DECLARE total_cuotas INT; -- Número total de cuotas del préstamo
    DECLARE i INT DEFAULT 1; -- Contador de cuotas, inicializado en 1
    DECLARE fecha_aprobacion DATE; -- Fecha de aprobación del préstamo
    DECLARE fecha_pago DATE; -- Fecha de pago calculada para cada cuota
    DECLARE es_primer_pago BOOLEAN DEFAULT TRUE; -- Indica si es el primer pago
    DECLARE dia_pago INT; -- Variable para almacenar el día de fecha_pago
    DECLARE ultimo_dia_mes INT; -- Variable para almacenar el mes de fecha_pago

    -- Obtener el número total de cuotas del préstamo usando el ID del préstamo
    SELECT Cuotas INTO total_cuotas
    FROM Prestamos
    WHERE IdPrestamo = prestamo_id;

    -- Obtener la fecha de aprobación del préstamo usando el ID del préstamo
    SELECT FechaDeAprobacion INTO fecha_aprobacion
    FROM Prestamos
    WHERE IdPrestamo = prestamo_id;

    -- Calcular la fecha de pago inicial con prórroga
    -- Si la fecha de aprobación es entre el día 1 y 15 del mes
    IF DAY(fecha_aprobacion) <= 15 THEN
        SET fecha_pago = LAST_DAY(fecha_aprobacion); -- La fecha de pago es el último día del mes
    ELSE
        SET fecha_pago = DATE_ADD(LAST_DAY(fecha_aprobacion), INTERVAL 15 DAY); -- La fecha de pago es 15 días después del último día del mes
    END IF;

    -- Ajustar la fecha de pago si cae en domingo (1 = Domingo en MySQL)
    IF DAYOFWEEK(fecha_pago) = 1 THEN
        SET fecha_pago = DATE_SUB(fecha_pago, INTERVAL 1 DAY); -- Retroceder un día si es domingo
    END IF;

    -- Insertar la primera fecha de pago en la tabla RegistroPagos
    INSERT INTO RegistroPagos (NumeroDeCuota, FechaDePago, EstadoCuota, IdPrestamo)
    VALUES (i, fecha_pago, 'P', prestamo_id);

    -- Incrementar el contador de cuotas para la siguiente iteración
    SET i = i + 1;

    -- Bucle para calcular y registrar las fechas de pago para las cuotas restantes
    WHILE i <= total_cuotas DO
		-- Calcular la próxima fecha de pago
		IF DAY(fecha_pago) <= 15 THEN
			SET fecha_pago = LAST_DAY(fecha_pago); -- Moverse al último día del mes
		ELSE
			SET fecha_pago = DATE_ADD(LAST_DAY(fecha_pago), INTERVAL 15 DAY); -- Moverse al último día del mes y añadir 15 días
		END IF;

		-- Ajustar la fecha de pago si cae en domingo (1 = Domingo en MySQL)
		IF DAYOFWEEK(fecha_pago) = 1 THEN
			SET fecha_pago = DATE_SUB(fecha_pago, INTERVAL 1 DAY); -- Retroceder un día si es domingo
		END IF;

		-- Insertar la fecha de pago calculada en la tabla RegistroPagos
		INSERT INTO RegistroPagos (NumeroDeCuota, FechaDePago, EstadoCuota, IdPrestamo)
		VALUES (i, fecha_pago, 'P', prestamo_id);

		-- Incrementar el contador de cuotas para la siguiente iteración
		SET i = i + 1;
	END WHILE;
END //
DELIMITER ;

-- Procedimientos Alejandro 2

DELIMITER //

CREATE PROCEDURE HistorialQuincenas(
    IN p_IdAdministrador INT -- Parámetro de entrada: ID del administrador para filtrar las cuotas
)
BEGIN
    SELECT 
        YEAR(rp.FechaDePago) AS Año, 
        MONTH(rp.FechaDePago) AS Mes,
        CASE 
            WHEN DAY(rp.FechaDePago) <= 15 THEN 'Primera Quincena'
            ELSE 'Segunda Quincena'
        END AS Quincena,
        rp.FechaDePago,
        COUNT(*) AS NumeroDeCuotasRegistradas
    FROM 
        RegistroPagos rp
    JOIN 
        Prestamos p ON rp.IdPrestamo = p.IdPrestamo -- Relación con la tabla Prestamos
    WHERE 
        p.IdAdministrador = p_IdAdministrador -- Filtrar por el ID del administrador
        AND rp.FechaDePago <= CURDATE() -- Filtrar por fechas de pago hasta la fecha actual
    GROUP BY 
        Año, Mes, Quincena, rp.FechaDePago
    ORDER BY 
        Año, Mes, Quincena, rp.FechaDePago;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE HistorialQuincenasGerente(
)
BEGIN
    SELECT 
        YEAR(rp.FechaDePago) AS Año, 
        MONTH(rp.FechaDePago) AS Mes,
        CASE 
            WHEN DAY(rp.FechaDePago) <= 15 THEN 'Primera Quincena'
            ELSE 'Segunda Quincena'
        END AS Quincena,
        rp.FechaDePago,
        COUNT(*) AS NumeroDeCuotasRegistradas
    FROM 
        RegistroPagos rp
    JOIN 
        Prestamos p ON rp.IdPrestamo = p.IdPrestamo -- Relación con la tabla Prestamos
    WHERE 
        rp.FechaDePago <= CURDATE() -- Filtrar por fechas de pago hasta la fecha actual
    GROUP BY 
        Año, Mes, Quincena, rp.FechaDePago
    ORDER BY 
        Año, Mes, Quincena, rp.FechaDePago;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerCuotasPorPagarHistorial (
    IN p_IdAdministrador INT,  -- Parámetro de entrada: ID del administrador para filtrar las cuotas por pagar
    IN p_FechaQuincena DATE    -- Parámetro de entrada: Fecha de la quincena para filtrar las cuotas por pagar
)
BEGIN
    -- Este procedimiento devuelve las cuotas pendientes de pago para la quincena especificada.

    DECLARE diaQuincena INT;        -- Variable para almacenar el día de la fecha de la quincena
    DECLARE mesQuincena INT;        -- Variable para almacenar el mes de la fecha de la quincena
    DECLARE anioQuincena INT;       -- Variable para almacenar el año de la fecha de la quincena
    DECLARE diaFinalMes INT;        -- Variable para almacenar el último día del mes de la quincena

    -- Obtener el día, el mes y el año de la fecha de la quincena
    SET diaQuincena = DAY(p_FechaQuincena);
    SET mesQuincena = MONTH(p_FechaQuincena);
    SET anioQuincena = YEAR(p_FechaQuincena);
    SET diaFinalMes = DAY(LAST_DAY(p_FechaQuincena));

    -- Seleccionar las cuotas pendientes de pago para la quincena especificada
    SELECT 
        rp.IdRegistroPago,                         -- ID del registro de pago
        rp.FechaDePago,                            -- Fecha de pago de la cuota
        rp.NumeroDeCuota,                          -- Número de la cuota
        c.CedulaColaborador,                       -- Cédula del colaborador
        c.NombresColaborador,                      -- Nombres del colaborador
        c.ApellidosColaborador,                    -- Apellidos del colaborador
        rp.EstadoCuota,                            -- Estado de la cuota (pendiente, pagada, etc.)
        p.IdPrestamo,                              -- ID del préstamo asociado a la cuota
        p.PlazoDePago_Meses,                       -- Plazo de pago en meses del préstamo
        p.Capital,                                 -- Capital del préstamo
        p.Intereses                                -- Intereses del préstamo
    FROM 
        Colaboradores c                             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        RegistroPagos rp ON p.IdPrestamo = rp.IdPrestamo -- Relación con registros de pagos
    WHERE 
        p.IdAdministrador = p_IdAdministrador          -- Filtrar por el ID del administrador
        AND (rp.EstadoCuota = 'C')                      -- Filtrar por cuotas pendientes de pago
        AND MONTH(rp.FechaDePago) = mesQuincena        -- Filtrar por el mes de la quincena
        AND YEAR(rp.FechaDePago) = anioQuincena        -- Filtrar por el año de la quincena
        AND (
            (diaQuincena <= 15 AND DAY(rp.FechaDePago) BETWEEN 1 AND 15) OR -- Si es la primera quincena del mes
            (diaQuincena > 15 AND DAY(rp.FechaDePago) BETWEEN 16 AND diaFinalMes) -- Si es la segunda quincena del mes
        );
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE ObtenerCuotasPorPagarHistorialGerente (
    IN p_FechaQuincena DATE    -- Parámetro de entrada: Fecha de la quincena para filtrar las cuotas por pagar
)
BEGIN	
    -- Este procedimiento devuelve las cuotas pendientes de pago para la quincena especificada.

    DECLARE diaQuincena INT;        -- Variable para almacenar el día de la fecha de la quincena
    DECLARE mesQuincena INT;        -- Variable para almacenar el mes de la fecha de la quincena
    DECLARE anioQuincena INT;       -- Variable para almacenar el año de la fecha de la quincena
    DECLARE diaFinalMes INT;        -- Variable para almacenar el último día del mes de la quincena

    -- Obtener el día, el mes y el año de la fecha de la quincena
    SET diaQuincena = DAY(p_FechaQuincena);
    SET mesQuincena = MONTH(p_FechaQuincena);
    SET anioQuincena = YEAR(p_FechaQuincena);
    SET diaFinalMes = DAY(LAST_DAY(p_FechaQuincena));

    -- Seleccionar las cuotas pendientes de pago para la quincena especificada
    SELECT 
        rp.IdRegistroPago,                         -- ID del registro de pago
        rp.FechaDePago,                            -- Fecha de pago de la cuota
        rp.NumeroDeCuota,                          -- Número de la cuota
        c.CedulaColaborador,                       -- Cédula del colaborador
        c.NombresColaborador,                      -- Nombres del colaborador
        c.ApellidosColaborador,                    -- Apellidos del colaborador
        rp.EstadoCuota,                            -- Estado de la cuota (pendiente, pagada, etc.)
        p.IdPrestamo,                              -- ID del préstamo asociado a la cuota
        p.PlazoDePago_Meses,                       -- Plazo de pago en meses del préstamo
        p.Capital,                                 -- Capital del préstamo
        p.Intereses                                -- Intereses del préstamo
    FROM 
        Colaboradores c                             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        RegistroPagos rp ON p.IdPrestamo = rp.IdPrestamo -- Relación con registros de pagos
    WHERE 
        rp.EstadoCuota = 'C'
        AND MONTH(rp.FechaDePago) = mesQuincena        -- Filtrar por el mes de la quincena
        AND YEAR(rp.FechaDePago) = anioQuincena        -- Filtrar por el año de la quincena
        AND (
            (diaQuincena <= 15 AND DAY(rp.FechaDePago) BETWEEN 1 AND 15) OR -- Si es la primera quincena del mes
            (diaQuincena > 15 AND DAY(rp.FechaDePago) BETWEEN 16 AND diaFinalMes) -- Si es la segunda quincena del mes
        );
END //

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE PrestamosCanceladosTodasLasSucursales()
BEGIN
    -- Selección de los datos relevantes sobre los préstamos activos y sus colaboradores asociados
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha de aprobación del préstamo
        c.CedulaColaborador,         -- Cédula del colaborador
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (se espera que sea 'A' para activos)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,             -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    WHERE 
        pr.EstadoPrestamo = 'C';     -- Filtro para seleccionar solo préstamos activos
END //

DELIMITER ;

-- -------------------------------- Prestamos Activos por IdSucursal
DELIMITER //

CREATE PROCEDURE PrestamosActivosPorSucursal(
    IN IdSucursal INT -- Parámetro de entrada: ID de la sucursal para filtrar los préstamos
)
BEGIN
    -- Selección de los datos relevantes sobre los préstamos activos y sus colaboradores asociados
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha de aprobación del préstamo
        c.CedulaColaborador,         -- Cédula del colaborador
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (se espera que sea 'A' para activos)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,             -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        Sucursales s ON c.IdSucursal = s.IdSucursal -- Relación con sucursales
    WHERE 
        pr.EstadoPrestamo = 'A'      -- Filtro para seleccionar solo préstamos activos
    AND 
        s.IdSucursal = IdSucursal;   -- Filtro para seleccionar préstamos asociados a la sucursal específica
END //

DELIMITER ;

-- ------------------------- Prestamos cancelados por IdSucursal

DELIMITER //

CREATE PROCEDURE PrestamosCanceladosPorSucursal(
    IN IdSucursal INT -- Parámetro de entrada: ID de la sucursal para filtrar los préstamos cancelados
)
BEGIN
    -- Consulta para obtener la información de los préstamos cancelados, junto con los detalles de los colaboradores
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha en que se aprobó el préstamo
        c.CedulaColaborador,         -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (esperado que sea 'C' para cancelados)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,             -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    JOIN 
        Sucursales s ON c.IdSucursal = s.IdSucursal -- Relación con sucursales
    WHERE 
        pr.EstadoPrestamo = 'C'      -- Filtro para seleccionar solo préstamos cancelados
    AND 
        s.IdSucursal = IdSucursal;   -- Filtro para seleccionar préstamos asociados a la sucursal específica
END //

DELIMITER ;

---- Solicitudes en espera de todas las sucursales

DELIMITER //

CREATE PROCEDURE SolicitudesEnEsperaTodasSucursales()
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos en espera, junto con los detalles de los colaboradores
    SELECT 
        sp.FechaDeSolicitud,         -- Fecha en que se realizó la solicitud de préstamo
        c.CedulaColaborador,         -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        sp.MontoSolicitado,          -- Monto solicitado en el préstamo
        sp.PlazoDePago,              -- Plazo de pago del préstamo
        sp.IdColaborador,            -- ID del colaborador
        sp.IdSolicitudesPrestamos          
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con la tabla de colaboradores
    JOIN 
        Sucursales s ON c.IdSucursal = s.IdSucursal           -- Relación con la tabla de sucursales
    WHERE 
        sp.EstadoSolicitud = 'E';    -- Filtro para seleccionar solo las solicitudes en estado "E" (en espera)
END //

DELIMITER ;

-- ----------------- Solicitudes en espera por IdSucursal
DELIMITER //

CREATE PROCEDURE SolicitudesEsperaPorSucursal(
    IN IdSucursal INT -- Parámetro de entrada: ID de la sucursal para filtrar las solicitudes en espera
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos en espera, junto con los detalles de los colaboradores
    SELECT 
        sp.FechaDeSolicitud,         -- Fecha en que se realizó la solicitud de préstamo
        c.CedulaColaborador,         -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        sp.MontoSolicitado,          -- Monto solicitado en el préstamo
        sp.PlazoDePago,              -- Plazo de pago del préstamo
        sp.IdColaborador,            -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador -- Relación con la tabla de colaboradores
    JOIN
        Sucursales s ON c.IdSucursal = s.IdSucursal -- Relación con la tabla de sucursales
    WHERE 
        sp.EstadoSolicitud = 'E'     -- Filtro para seleccionar solo las solicitudes en estado "E" (en espera)
    AND
        s.IdSucursal = IdSucursal;   -- Filtro para seleccionar solicitudes gestionadas por la sucursal específica
END //

DELIMITER ;

-- --------------------------------------- Solicitudes aceptadas de todas las sucursales
DELIMITER //

CREATE PROCEDURE SolicitudesAceptadasTodasSucursales()
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos aceptadas, junto con los detalles de los colaboradores y préstamos
    SELECT 
        p.FechaDeAprobacion,        -- Fecha en que se aprobó el préstamo
        c.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,       -- Nombres del colaborador
        c.ApellidosColaborador,     -- Apellidos del colaborador
        pr.Capital,                 -- Capital del préstamo aprobado
        pr.PlazoDePago_Meses,       -- Plazo de pago del préstamo en meses
        pr.Cuotas                   -- Número de cuotas del préstamo
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador     -- Relación con la tabla de colaboradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con la tabla de préstamos
    JOIN 
        (SELECT IdPrestamo, FechaDeAprobacion FROM Prestamos) p ON pr.IdPrestamo = p.IdPrestamo -- Relación para obtener la fecha de aprobación del préstamo
    WHERE 
        sp.EstadoSolicitud = 'A';    -- Filtro para seleccionar solo las solicitudes en estado "A" (aceptadas)
END //

DELIMITER ;

-- ---------------------------- Solicitudes aceptadas por IdSucursal
DELIMITER //

CREATE PROCEDURE SolicitudesAceptadasPorSucursal(
    IN IdSucursal INT -- Parámetro de entrada: ID de la sucursal para filtrar las solicitudes aceptadas
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos aceptadas, junto con los detalles de los colaboradores y préstamos
    SELECT 
        p.FechaDeAprobacion,        -- Fecha en que se aprobó el préstamo
        c.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        c.NombresColaborador,       -- Nombres del colaborador
        c.ApellidosColaborador,     -- Apellidos del colaborador
        pr.Capital,                 -- Capital del préstamo aprobado
        pr.PlazoDePago_Meses,       -- Plazo de pago del préstamo en meses
        pr.Cuotas                   -- Número de cuotas del préstamo
    FROM 
        SolicitudesPrestamos sp      -- Tabla de solicitudes de préstamos
    JOIN 
        Colaboradores c ON sp.IdColaborador = c.IdColaborador     -- Relación con la tabla de colaboradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con la tabla de préstamos
    JOIN 
        (SELECT IdPrestamo, FechaDeAprobacion FROM Prestamos) p ON pr.IdPrestamo = p.IdPrestamo -- Relación para obtener la fecha de aprobación del préstamo
    JOIN
        Sucursales s ON c.IdSucursal = s.IdSucursal -- Relación con la tabla de sucursales
    WHERE 
        sp.EstadoSolicitud = 'A'     -- Filtro para seleccionar solo las solicitudes en estado "A" (aceptadas)
    AND 
        s.IdSucursal = IdSucursal;   -- Filtro para seleccionar solicitudes asociadas a la sucursal específica
END //

DELIMITER ;

-- ----------------------------- Solicitudes Denegadas de todas las sucursales
DELIMITER //

CREATE PROCEDURE SolicitudesDenegadasTodasSucursales()
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos denegadas, junto con los detalles de los colaboradores
    SELECT 
        SP.FechaDeSolicitud,        -- Fecha en que se realizó la solicitud de préstamo
        C.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        C.NombresColaborador,       -- Nombres del colaborador
        C.ApellidosColaborador,     -- Apellidos del colaborador
        SP.MontoSolicitado,         -- Monto solicitado en el préstamo
        SP.PlazoDePago,             -- Plazo de pago del préstamo solicitado
        S.IdSucursal                -- ID de la sucursal
    FROM
        Colaboradores C             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos SP ON C.IdColaborador = SP.IdColaborador -- Relación con la tabla de solicitudes de préstamos
    JOIN
        Sucursales S ON C.IdSucursal = S.IdSucursal -- Relación con la tabla de sucursales
    WHERE
        SP.EstadoSolicitud = 'D';   -- Filtro para seleccionar solo las solicitudes en estado "D" (denegadas)
END //

DELIMITER ;

-- ---------------------------- Solicitudes denegadas por IdSucursal
DELIMITER //

CREATE PROCEDURE SolicitudesDenegadasPorSucursal(
    IN IdSucursal INT -- Parámetro de entrada: ID de la sucursal para filtrar las solicitudes denegadas
)
BEGIN
    -- Consulta para obtener la información de las solicitudes de préstamos denegadas, junto con los detalles de los colaboradores
    SELECT 
        SP.FechaDeSolicitud,        -- Fecha en que se realizó la solicitud de préstamo
        C.CedulaColaborador,        -- Cédula del colaborador que solicitó el préstamo
        C.NombresColaborador,       -- Nombres del colaborador
        C.ApellidosColaborador,     -- Apellidos del colaborador
        SP.MontoSolicitado,         -- Monto solicitado en el préstamo
        SP.PlazoDePago              -- Plazo de pago del préstamo solicitado
    FROM
        Colaboradores C             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos SP ON C.IdColaborador = SP.IdColaborador -- Relación con la tabla de solicitudes de préstamos
    JOIN
        Sucursales S ON C.IdSucursal = S.IdSucursal -- Relación con la tabla de sucursales
    WHERE
        SP.EstadoSolicitud = 'D'    -- Filtro para seleccionar solo las solicitudes en estado "D" (denegadas)
    AND 
        S.IdSucursal = IdSucursal;  -- Filtro para seleccionar solicitudes asociadas a la sucursal específica
END //

DELIMITER ;

-- -------------- CRUD ADMIN

DELIMITER //

CREATE PROCEDURE PrestamosActivosTodasLasSucursales()
BEGIN
    -- Selección de los datos relevantes sobre los préstamos activos y sus colaboradores asociados
    SELECT 
        pr.FechaDeAprobacion,        -- Fecha de aprobación del préstamo
        c.CedulaColaborador,         -- Cédula del colaborador
        c.NombresColaborador,        -- Nombres del colaborador
        c.ApellidosColaborador,      -- Apellidos del colaborador
        pr.EstadoPrestamo,           -- Estado del préstamo (se espera que sea 'A' para activos)
        pr.Capital,                  -- Capital del préstamo
        c.IdColaborador,             -- ID del colaborador
        sp.IdSolicitudesPrestamos    -- ID de la solicitud de préstamo
    FROM 
        Colaboradores c              -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Administrador a ON sp.IdAdministrador = a.IdAdministrador     -- Relación con administradores
    JOIN 
        Prestamos pr ON sp.IdSolicitudesPrestamos = pr.IdSolicitudesPrestamos -- Relación con préstamos
    WHERE 
        pr.EstadoPrestamo = 'A';     -- Filtro para seleccionar solo préstamos activos
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CambiarEstadoAdministrador(
    IN p_IdAdmin INT
)
BEGIN
    -- Verificar si el colaborador existe
    IF EXISTS (SELECT 1 FROM Administrador WHERE IdAdministrador = p_IdAdmin) THEN
        -- Actualizar el estado del colaborador a "D" (Despedido)
        UPDATE Administrador
        SET EstadoAdministrador = '0' -- '1' activo '0' despedido
        WHERE IdAdministrador = p_IdAdmin;
    END IF;
END //
DELIMITER ;

DELIMITER //
-- Procedimiento para insertar un nuevo administrador en la tabla Administrador
CREATE PROCEDURE InsertarAdministrador(
    IN p_CedulaAdministrador VARCHAR(16),    -- Cédula del administrador
    IN p_NombresAdministrador VARCHAR(50),   -- Nombres del administrador
    IN p_ApellidosAdministrador VARCHAR(50), -- Apellidos del administrador
    IN p_CorreoAdministrador VARCHAR(50),    -- Correo electrónico del administrador
    IN p_NumeroTelefonoAdministrador VARCHAR(10), -- Número de teléfono del administrador
    IN p_Usuario VARCHAR(50),                -- Nombre de usuario del administrador
    IN p_Contrasenia CHAR(102),              -- Contraseña del administrador
    IN p_EstadoAdministrador CHAR(1),        -- Estado del administrador
    IN p_IdSucursal INT                       -- ID de la sucursal del administrador
)
BEGIN
    -- Inserta un nuevo administrador en la tabla Administrador con los datos proporcionados
    INSERT INTO Administrador (
        CedulaAdministrador,                 -- Cédula del administrador
        NombresAdministrador,                -- Nombres del administrador
        ApellidosAdministrador,              -- Apellidos del administrador
        CorreoAdministrador,                 -- Correo electrónico del administrador
        NumeroTelefonoAdministrador,         -- Número de teléfono del administrador
        Usuario,                             -- Nombre de usuario del administrador
        Contrasenia,                         -- Contraseña del administrador
        EstadoAdministrador,                 -- Estado del administrador
        IdSucursal                           -- ID de la sucursal del administrador
    )
    VALUES (
        p_CedulaAdministrador,               -- Valor del parámetro Cédula del administrador
        p_NombresAdministrador,              -- Valor del parámetro Nombres del administrador
        p_ApellidosAdministrador,            -- Valor del parámetro Apellidos del administrador
        p_CorreoAdministrador,               -- Valor del parámetro Correo electrónico del administrador
        p_NumeroTelefonoAdministrador,       -- Valor del parámetro Número de teléfono del administrador
        p_Usuario,                           -- Valor del parámetro Nombre de usuario del administrador
        p_Contrasenia,                       -- Valor del parámetro Contraseña del administrador
        p_EstadoAdministrador,               -- Valor del parámetro Estado del administrador
        p_IdSucursal                         -- Valor del parámetro ID de la sucursal del administrador
    );
END//
DELIMITER ;

DELIMITER //
-- Procedimiento para modificar datos del administrador
CREATE PROCEDURE ModificarAdministrador(
    IN administrador_id INT,               -- ID del administrador a modificar
    IN nuevo_cedula VARCHAR(16),          -- Nueva cédula del administrador
    IN nuevo_nombre VARCHAR(50),          -- Nuevo nombre del administrador
    IN nuevo_apellido VARCHAR(50),        -- Nuevo apellido del administrador
    IN nuevo_correo VARCHAR(50),          -- Nuevo correo del administrador
    IN nuevo_telefono VARCHAR(10),        -- Nuevo número de teléfono del administrador            -- Nuevo estado del administrador
    IN nuevo_id_sucursal INT              -- Nuevo ID de la sucursal del administrador
)
BEGIN
    -- Actualiza los datos del administrador con el ID especificado en la tabla Administrador
    UPDATE Administrador SET 
        CedulaAdministrador = nuevo_cedula,                 -- Actualiza la cédula del administrador
        NombresAdministrador = nuevo_nombre,                -- Actualiza el nombre del administrador
        ApellidosAdministrador = nuevo_apellido,            -- Actualiza el apellido del administrador
        CorreoAdministrador = nuevo_correo,                 -- Actualiza el correo del administrador
        NumeroTelefonoAdministrador = nuevo_telefono,       -- Actualiza el número de teléfono del administrador                       -- Actualiza el nombre de usuario del administrador                -- Actualiza la contraseña del administrador            -- Actualiza el estado del administrador
        IdSucursal = nuevo_id_sucursal                      -- Actualiza el ID de la sucursal del administrador
    WHERE IdAdministrador = administrador_id;               -- Condición para identificar el administrador a modificar
END //
DELIMITER ;

-- -------------------------- Cheques a generar
DELIMITER //

CREATE PROCEDURE ObtenerChequesPorGenerarTodasLasSucursales(
    IN p_FechaActual DATE
)
BEGIN
    SELECT 
        c.CedulaColaborador,
        c.NombresColaborador,
        c.ApellidosColaborador,
        c.IdSucursal,
        p.IdPrestamo,
        p.FechaDeAprobacion,
        p.Capital
    FROM 
        Colaboradores c                             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos
    WHERE 
        p.FechaDeAprobacion BETWEEN DATE_SUB(p_FechaActual, INTERVAL 7 DAY) AND p_FechaActual
        AND p.EstadoPrestamo = 'A';
END //
DELIMITER ;

-- Procedimientos Dashboard --
-- Ultimos 10 Prestamos Creados
DELIMITER //
CREATE PROCEDURE UltimosPrestamosCreados(
)
BEGIN
	SELECT 
		p.IdPrestamo,
		p.FechaDeAprobacion,
		p.Capital,
		p.Intereses,
		p.Cuotas,
		s.nombreDeSucursal,
		s.direccionSucursal,
		c.NombresColaborador,
		c.ApellidosColaborador,
        c.CedulaColaborador,
        sp.IdSolicitudesPrestamos
	FROM 
		Prestamos p
	JOIN 
		SolicitudesPrestamos sp ON p.IdSolicitudesPrestamos = sp.IdSolicitudesPrestamos
	JOIN 
		Colaboradores c ON sp.IdColaborador = c.IdColaborador
	JOIN 
		Administrador a ON p.IdAdministrador = a.IdAdministrador
	JOIN 
		Sucursales s ON c.IdSucursal = s.IdSucursal
	JOIN 
		UnidadDeNegocio un ON s.IdUnidadDeNegocio = un.IdUnidadDeNegocio
	ORDER BY 
		p.FechaDeAprobacion DESC
	LIMIT 10;
END //
DELIMITER ;

-- Numero de Colaboradores por Unidad de Negocio 
DELIMITER //
CREATE PROCEDURE NumeroDeColaboradoresPorUnidadDeNegocio(
)
BEGIN
	SELECT 
		u.nombreUnidadDeNegocio,
		COUNT(c.IdColaborador) AS NumeroDeColaboradores
	FROM 
		UnidadDeNegocio u
	LEFT JOIN 
		Sucursales s ON u.IdUnidadDeNegocio = s.IdUnidadDeNegocio
	LEFT JOIN 
		Colaboradores c ON s.IdSucursal = c.IdSucursal
	GROUP BY 
		u.IdUnidadDeNegocio, u.nombreUnidadDeNegocio;
END //
DELIMITER ;

-- query cantidad de capital prestado por Unidad de Negocio 
DELIMITER //
CREATE PROCEDURE CapitalPrestadoPorUnidadDeNegocio(
)
BEGIN
	SELECT 
		u.nombreUnidadDeNegocio,
		IFNULL(SUM(p.Capital), 0) AS TotalCapitalPrestado
	FROM 
		UnidadDeNegocio u
	LEFT JOIN 
		Sucursales s ON u.IdUnidadDeNegocio = s.IdUnidadDeNegocio
	LEFT JOIN 
		Colaboradores c ON s.IdSucursal = c.IdSucursal
	LEFT JOIN 
		SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador
	LEFT JOIN 
		Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos
	GROUP BY 
		u.IdUnidadDeNegocio, u.nombreUnidadDeNegocio;
END //
DELIMITER ;
    

DELIMITER //
CREATE PROCEDURE InteresPorUnidadDeNegocio (
    IN p_FechaQuincena DATE    -- Parámetro de entrada: Fecha de la quincena para filtrar las cuotas por pagar
)
BEGIN
    -- Este procedimiento devuelve las cuotas pendientes de pago para la quincena especificada.

    DECLARE diaQuincena INT;        -- Variable para almacenar el día de la fecha de la quincena
    DECLARE mesQuincena INT;        -- Variable para almacenar el mes de la fecha de la quincena
    DECLARE anioQuincena INT;       -- Variable para almacenar el año de la fecha de la quincena
    DECLARE diaFinalMes INT;        -- Variable para almacenar el último día del mes de la quincena

    -- Obtener el día, el mes y el año de la fecha de la quincena
    SET diaQuincena = DAY(p_FechaQuincena);
    SET mesQuincena = MONTH(p_FechaQuincena);
    SET anioQuincena = YEAR(p_FechaQuincena);
    SET diaFinalMes = DAY(LAST_DAY(p_FechaQuincena));

    -- Seleccionar las cuotas pendientes de pago para la quincena especificada
    SELECT 
        rp.IdRegistroPago,                         -- ID del registro de pago
        rp.FechaDePago,                            -- Fecha de pago de la cuota
        rp.NumeroDeCuota,                          -- Número de la cuota
        c.CedulaColaborador,                       -- Cédula del colaborador
        c.NombresColaborador,                      -- Nombres del colaborador
        c.ApellidosColaborador,                    -- Apellidos del colaborador
        rp.EstadoCuota,                            -- Estado de la cuota (pendiente, pagada, etc.)
        p.IdPrestamo,                              -- ID del préstamo asociado a la cuota
        p.PlazoDePago_Meses,                       -- Plazo de pago en meses del préstamo
        p.Capital,                                 -- Capital del préstamo
        p.Intereses,                               -- Intereses del préstamo
        u.nombreUnidadDeNegocio                    -- Nombre de la unidad de negocio
    FROM 
        Colaboradores c                             -- Tabla de colaboradores
    JOIN 
        SolicitudesPrestamos sp ON c.IdColaborador = sp.IdColaborador -- Relación con solicitudes de préstamos
    JOIN 
        Prestamos p ON sp.IdSolicitudesPrestamos = p.IdSolicitudesPrestamos
    JOIN 
        RegistroPagos rp ON p.IdPrestamo = rp.IdPrestamo -- Relación con registros de pagos
    JOIN 
        Sucursales s ON c.IdSucursal = s.IdSucursal -- Relación con sucursales
    JOIN 
        UnidadDeNegocio u ON s.IdUnidadDeNegocio = u.IdUnidadDeNegocio -- Relación con unidades de negocio
    WHERE 
        rp.EstadoCuota = 'P'                       -- Filtrar por cuotas pendientes de pago
        AND MONTH(rp.FechaDePago) = mesQuincena        -- Filtrar por el mes de la quincena
        AND YEAR(rp.FechaDePago) = anioQuincena        -- Filtrar por el año de la quincena
        AND (
            (diaQuincena <= 15 AND DAY(rp.FechaDePago) BETWEEN 1 AND 15) OR -- Si es la primera quincena del mes
            (diaQuincena > 15 AND DAY(rp.FechaDePago) BETWEEN 16 AND diaFinalMes) -- Si es la segunda quincena del mes
        );
END //
DELIMITER ;

-- SE CAMBIO PARA QUE FUNCIONE EL DETALLE PRESTAMO CON MUCHAS PALABRAS

-- Este procedimiento insertar los datos de una solicitud de un colaborador en especificos
DELIMITER //

CREATE PROCEDURE InsertarSolicitudPrestamos(
    IN p_FechaDeSolicitud VARCHAR(10),   -- Fecha de la solicitud de préstamo
    IN p_MontoSolicitado DECIMAL(15,2),  -- Monto solicitado para el préstamo
    IN p_PlazoDePago INT,                -- Plazo de pago en meses
    IN p_MotivoDePrestamo TEXT,   -- Motivo del préstamo
    IN p_EstadoDeSolicitud CHAR(1),      -- Estado de la solicitud (por ejemplo, 'E' para en espera, 'A' para aceptada, 'D' para denegada)
    IN p_IdColaborador INT,              -- ID del colaborador que solicita el préstamo
    IN p_IdAdministrador INT             -- ID del administrador que procesa la solicitud
)
BEGIN 
    -- Inserta una nueva solicitud de préstamo en la tabla SolicitudesPrestamos
    INSERT INTO SolicitudesPrestamos (
        FechaDeSolicitud, 
        MontoSolicitado, 
        PlazoDePago, 
        MotivoPrestamo, 
        EstadoSolicitud, 
        IdColaborador, 
        IdAdministrador
    ) 
    VALUES (
        p_FechaDeSolicitud,     -- Fecha de la solicitud
        p_MontoSolicitado,      -- Monto solicitado para el préstamo
        p_PlazoDePago,          -- Plazo de pago en meses
        p_MotivoDePrestamo,     -- Motivo del préstamo
        p_EstadoDeSolicitud,    -- Estado de la solicitud
        p_IdColaborador,        -- ID del colaborador que solicita el préstamo
        p_IdAdministrador       -- ID del administrador que procesa la solicitud
    );
END//
DELIMITER ;


