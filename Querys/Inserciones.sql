use grupotalse;
-- Inserción en la tabla UnidadDeNegocio
-- Cambio de nombre reciente a 'Mi Ranchito'
INSERT INTO UnidadDeNegocio (nombreUnidadDeNegocio, cantidadDeSucursales)
VALUES ('Mi viejo Ranchito', 4);

INSERT INTO UnidadDeNegocio (nombreUnidadDeNegocio, cantidadDeSucursales)
VALUES ('El Zocalo', 3);

INSERT INTO UnidadDeNegocio (nombreUnidadDeNegocio, cantidadDeSucursales)
VALUES ('La Nani Cafe', 2);

INSERT INTO UnidadDeNegocio (nombreUnidadDeNegocio, cantidadDeSucursales)
VALUES ('Setenta Grados', 1);

INSERT INTO UnidadDeNegocio (nombreUnidadDeNegocio, cantidadDeSucursales)
VALUES ('La Sureña', 1);

-- Inserción en la tabla Sucursales
-- Sucursales Mi Ranchito
INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('Mi viejo Ranchito', 'Rivas', '2560 2137', 1);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('Mi viejo Ranchito', 'Catarina', '2558 0473', 1);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('Mi viejo Ranchito', 'Masaya', '2279 2865', 1);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('Mi viejo Ranchito', 'Galeria', '8590 3886', 1);

-- Sucursales El zocalo
INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('El Zocalo', 'Masaya', '7530 6452', 2);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('El Zocalo', 'Villa Fontana', '7530 6452', 2);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('El Zocalo', 'Galeria', '7530 6452', 2);

-- Sucursales la Nani
INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('La Nani Cafe', 'Rivas', '8881 4246', 3);

INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('La Nani Cafe', 'Masaya', '2522 0239', 3);

-- Sucursales Setenta grados
INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('Setenta Grados', 'Rivas', '8244 5592', 4);

-- Sucursales Sureña
INSERT INTO Sucursales (nombreDeSucursal, direccionSucursal, numeroTelefonoSucursal, IdUnidadDeNegocio)
VALUES ('La Sureña', 'Rivas', '7620 5533', 5);
