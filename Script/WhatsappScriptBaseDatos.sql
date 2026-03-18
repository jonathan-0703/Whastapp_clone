CREATE DATABASE WhatsappProyectoFinal

USE WhatsappProyectoFinal

--DDL

CREATE TABLE Usuarios(
	UsuarioId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID() ,
	Nombre NVARCHAR(250) NOT NULL,
	Descripcion NVARCHAR(255),
	FotoPerfil TEXT NOT NULL,
	Telefono NVARCHAR(20) NOT NULL,
	FechaCreacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()

);
GO 

INSERT INTO Usuarios (Nombre, Descripcion, FotoPerfil, Telefono)
VALUES 
('Juan Perez', 'Backend developer', 'foto1.jpg', '0991111111'),
('Maria Lopez', 'Frontend developer', 'foto2.jpg', '0992222222'),
('Carlos Ruiz', 'QA Tester', 'foto3.jpg', '0993333333');

GO
CREATE TABLE Grupos(
	GrupoId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nombre NVARCHAR(250) NOT NULL,
	FotoGrupal NVARCHAR(MAX),
	Descripcion NVARCHAR(250),
);
GO
INSERT INTO Grupos (Nombre, FotoGrupal, Descripcion)
VALUES 
('Grupo Devs', 'grupo1.jpg', 'Equipo de desarrollo'),
('Grupo QA', 'grupo2.jpg', 'Equipo de testing');

GO
CREATE TABLE UsuariosGrupos(
	UsuarioGrupos INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UsuarioId UNIQUEIDENTIFIER NOT NULL ,
	GrupoId INT NOT NULL,
	CONSTRAINT FK_UsuariosGrupos FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
	CONSTRAINT FK_GruposUsuarios FOREIGN KEY (GrupoId) REFERENCES Grupos(GrupoId)
);
GO

INSERT INTO UsuariosGrupos (UsuarioId, GrupoId)
SELECT u.UsuarioId, g.GrupoId
FROM Usuarios u, Grupos g
WHERE u.Nombre = 'Juan Perez' AND g.Nombre = 'Grupo Devs';

INSERT INTO UsuariosGrupos (UsuarioId, GrupoId)
SELECT u.UsuarioId, g.GrupoId
FROM Usuarios u, Grupos g
WHERE u.Nombre = 'Maria Lopez' AND g.Nombre = 'Grupo Devs';

GO
CREATE TABLE AdministradorGrupo(
	AdministadorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID() ,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	GrupoId INT NOT NULL,
	Permisos NVARCHAR(200) NOT NULL,
	Descripcion NVARCHAR(MAX),
	CONSTRAINT FK_AdminGrupos FOREIGN KEY (GrupoId) REFERENCES Grupos(GrupoId),
	CONSTRAINT FK_UsuarioAdministrador FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
);
GO

INSERT INTO AdministradorGrupo (UsuarioId, GrupoId, Permisos, Descripcion)
SELECT u.UsuarioId, g.GrupoId, 'ALL', 'Administrador principal'
FROM Usuarios u, Grupos g
WHERE u.Nombre = 'Juan Perez' AND g.Nombre = 'Grupo Devs';

GO
CREATE TABLE Bloqueo(
	BloqueadorId UNIQUEIDENTIFIER NOT NULL,
	BLoqueadoId UNIQUEIDENTIFIER NOT NULL,
	FechaBloqueo DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	PRIMARY KEY (BloqueadorId,BLoqueadoId),
	CONSTRAINT FK_BloqueadorId FOREIGN KEY (BloqueadorId) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_BLoqueadoId FOREIGN KEY (BLoqueadoId) REFERENCES Usuarios(UsuarioId)

); 
GO

INSERT INTO Bloqueo (BloqueadorId, BLoqueadoId)
SELECT u1.UsuarioId, u2.UsuarioId
FROM Usuarios u1, Usuarios u2
WHERE u1.Nombre = 'Juan Perez' AND u2.Nombre = 'Carlos Ruiz';

GO 

CREATE TABLE Estados(
	EstadosId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	URL NVARCHAR(MAX) NOT NULL,
	FechaPublicacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	FechaVencimiento DATETIME2  DEFAULT SYSUTCDATETIME()

	CONSTRAINT FK_UsuarioEstado FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
);
GO


GO

CREATE TABLE Conversaciones(
	ConversacionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nombre NVARCHAR(250) NOT NULL,
	Descripcion NVARCHAR(250),
	FechaCreacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	

);
GO

INSERT INTO Conversaciones (Nombre, Descripcion)
VALUES 
('Chat Juan y Maria', 'Conversacion privada'),
('Grupo Devs Chat', 'Chat del grupo devs');

GO

CREATE TABLE ConversacionUsuario(
	ConversacionUsuarioId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	ConversacionId INT NOT NULL,
	MensajeSilenciado BIT NOT NULL DEFAULT 1,
	CONSTRAINT FK_UsuarioConversion FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
	CONSTRAINT FK_ConversacionUsuario FOREIGN KEY (ConversacionId) REFERENCES Conversaciones(ConversacionId)
);
GO

INSERT INTO ConversacionUsuario (UsuarioId, ConversacionId)
SELECT u.UsuarioId, c.ConversacionId
FROM Usuarios u, Conversaciones c
WHERE u.Nombre = 'Juan Perez' AND c.Nombre = 'Chat Juan y Maria';

GO
INSERT INTO ConversacionUsuario (UsuarioId, ConversacionId)
SELECT u.UsuarioId, c.ConversacionId
FROM Usuarios u, Conversaciones c
WHERE u.Nombre = 'Maria Lopez' AND c.Nombre = 'Chat Juan y Maria';

GO

CREATE TABLE EstadoMensaje(
	EstadoMensajeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NombreEstado NVARCHAR(50)
);
GO

INSERT INTO EstadoMensaje (NombreEstado)
VALUES 
('Enviado'),
('Entregado'),
('Leido');

GO
CREATE TABLE Mensaje(
	MensajeId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ConversacionId INT NOT NULL,
	EstadoMensajeId INT NOT NULL,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	Contenido NVARCHAR(MAX),
	TipoDocumento NVARCHAR(MAX),
	FechaEnvio DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	MensajeEliminado BIT DEFAULT 0,
	RespuestaMensaje NVARCHAR(MAX),
	CONSTRAINT FK_UsuarioMensajeId FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
	CONSTRAINT FK_ConversaionMensajeId FOREIGN KEY (ConversacionId) REFERENCES Conversaciones(ConversacionId),
	CONSTRAINT FK_EstadoMensajeId FOREIGN KEY (EstadoMensajeId) REFERENCES EstadoMensaje(EstadoMensajeId)

);
GO

INSERT INTO Mensaje (ConversacionId, EstadoMensajeId, UsuarioId, Contenido, TipoDocumento)
SELECT 
    c.ConversacionId,
    1,
    u.UsuarioId,
    'Hola Maria!',
    'texto'
FROM Usuarios u, Conversaciones c
WHERE u.Nombre = 'Juan Perez' AND c.Nombre = 'Chat Juan y Maria';

GO
CREATE TABLE MensajeLeidos(
	MensajeLeidoID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	MensajeId INT NOT NULL,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	FechaLeido DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	CONSTRAINT FK_MensajeLeidoUsuario FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId),
	CONSTRAINT FK_MensajeLeido FOREIGN KEY (MensajeId) REFERENCES Mensaje(MensajeId),
	CONSTRAINT UQ_Mensaje_Usuario UNIQUE (MensajeId, UsuarioId)
);
GO

INSERT INTO MensajeLeidos (MensajeId, UsuarioId)
SELECT m.MensajeId, u.UsuarioId
FROM Mensaje m, Usuarios u
WHERE u.Nombre = 'Maria Lopez';

GO
CREATE TABLE Reacciones(
	ReaccionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	MensajeId INT NOT NULL,
	Emoji TEXT NOT NULL,
	FechaReaccion  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	CONSTRAINT FK_MensajeReaccion FOREIGN KEY (MensajeId) REFERENCES Mensaje(MensajeId),
	CONSTRAINT FK_UsuarioReaccion FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
);
GO

INSERT INTO Reacciones (UsuarioId, MensajeId, Emoji)
SELECT u.UsuarioId, m.MensajeId, '❤️'
FROM Usuarios u, Mensaje m
WHERE u.Nombre = 'Maria Lopez';

