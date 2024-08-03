Create database grupotalse;
use grupotalse;
CREATE TABLE UnidadDeNegocio (
	IdUnidadDeNegocio INT AUTO_INCREMENT PRIMARY KEY,
	nombreUnidadDeNegocio VARCHAR(50) NOT NULL,
	cantidadDeSucursales INT NOT NULL
);

CREATE TABLE Sucursales (
	IdSucursal INT AUTO_INCREMENT PRIMARY KEY,
	nombreDeSucursal VARCHAR(50) NOT NULL,
	direccionSucursal VARCHAR(50) NOT NULL,
	numeroTelefonoSucursal VARCHAR(10) NOT NULL,
	IdUnidadDeNegocio INT NOT NULL,
	CONSTRAINT FK_UnidadDeNegocioSucursal FOREIGN KEY (IdUnidadDeNegocio) REFERENCES UnidadDeNegocio(IdUnidadDeNegocio)
);

CREATE TABLE Colaboradores (
	IdColaborador INT AUTO_INCREMENT PRIMARY KEY,
	FechaContratacion DATE NOT NULL,
	CedulaColaborador VARCHAR(16) NOT NULL,
	NombresColaborador VARCHAR(50) NOT NULL,
	ApellidosColaborador VARCHAR(50) NOT NULL,
	SalarioColaborador DECIMAL(15,2) NOT NULL,
	TipoDeContrato CHAR(1) NOT NULL,
	EstadoCrediticio CHAR(1) NULL,  -- cambio para lo que dijo el profesor de agregar un colaborador sin estadoCredicticio 
	CorreoColaborador VARCHAR(50) NOT NULL,
	NumeroTelefonoColaborador VARCHAR(10) NOT NULL,
    Contrasenia char(102) NOT NULL,
	IdSucursal INT NOT NULL,
	EstadoColaborador CHAR(1) NOT NULL, -- A activo D despedido
	CONSTRAINT FK_SucursalColaborador FOREIGN KEY (IdSucursal) REFERENCES Sucursales(IdSucursal)
);

CREATE TABLE Administrador (
	IdAdministrador INT AUTO_INCREMENT PRIMARY KEY,
	CedulaAdministrador VARCHAR(16) NOT NULL,
	NombresAdministrador VARCHAR(50) NOT NULL,
	ApellidosAdministrador VARCHAR(50) NOT NULL,
	CorreoAdministrador VARCHAR(50) NOT NULL,
	NumeroTelefonoAdministrador VARCHAR(10) NOT NULL,
	Usuario VARCHAR(50) NOT NULL,
	Contrasenia char(102) NOT NULL,
	EstadoAdministrador CHAR(1) NOT NULL,
	IdSucursal INT NOT NULL,
	CONSTRAINT FK_SucursalAdministrador FOREIGN KEY (IdSucursal) REFERENCES Sucursales(IdSucursal)
);

CREATE TABLE SolicitudesPrestamos (
	IdSolicitudesPrestamos INT AUTO_INCREMENT PRIMARY KEY,
	FechaDeSolicitud DATE NOT NULL,
	MontoSolicitado DECIMAL(15,2) NOT NULL,
	PlazoDePago INT NOT NULL,
	MotivoPrestamo TEXT NOT NULL, -- SE CAMBIO A TIPO TEXT PORQUE VARCHAR NO ACEPTAS MUCHAS PALABRAS MontoSolicitado
	EstadoSolicitud CHAR(1) NOT NULL,
	IdColaborador INT NOT NULL,
	IdAdministrador INT NOT NULL,
	CONSTRAINT FK_ColaboradorSolicitudPrestamo FOREIGN KEY (IdColaborador) REFERENCES Colaboradores(IdColaborador),
	CONSTRAINT FK_AdministradorSolicitudPrestamo FOREIGN KEY (IdAdministrador) REFERENCES Administrador(IdAdministrador)
);

-- Eliminacion de campo CosteTotal
CREATE TABLE Prestamos (
	IdPrestamo INT AUTO_INCREMENT PRIMARY KEY,
	FechaDeAprobacion DATE NOT NULL,
	Capital DECIMAL(15,2) NOT NULL,
	Intereses DECIMAL(15,3) NOT NULL,
	Cuotas INT NOT NULL,
	PlazoDePago_Meses INT NOT NULL,
	EstadoPrestamo CHAR(1) NOT NULL,
    IdSolicitudesPrestamos INT NOT NULL,
	IdAdministrador INT NOT NULL,
	CONSTRAINT FK_AdministradorPrestamo FOREIGN KEY (IdAdministrador) REFERENCES Administrador(IdAdministrador),
    CONSTRAINT FK_SolicitudesPrestamosPrestamo FOREIGN KEY (IdSolicitudesPrestamos) REFERENCES SolicitudesPrestamos(IdSolicitudesPrestamos)
);

CREATE TABLE RegistroPagos(
	IdRegistroPago INT AUTO_INCREMENT PRIMARY KEY,
	NumeroDeCuota INT NOT NULL,
	FechaDePago DATE NOT NULL,
    EstadoCuota CHAR(1), -- ESTADO CUOTA 'P' PENDIENTE 'C' CANCELADA
	IdPrestamo INT NOT NULL,
	CONSTRAINT FK_PrestamosRegistroPagos FOREIGN KEY (IdPrestamo) REFERENCES Prestamos(IdPrestamo)
);
