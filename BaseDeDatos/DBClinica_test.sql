USE [DBClinica_test]
GO
/****** Object:  StoredProcedure [dbo].[spAccesoSistema]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAccesoSistema]
( @prmUser varchar(50),
  @prmPass varchar(50)
)
AS
	BEGIN
		SELECT E.idEmpleado, E.usuario, E.clave, E.nombres, E.apPaterno, E.apMaterno, E.nroDocumento
		FROM Empleado E
		WHERE E.usuario = @prmUser AND E.clave = @prmPass
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarDatosPaciente]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosPaciente]
(@prmIdPaciente int,
@prmDireccion varchar(300))
as
	begin
		update Paciente
		set Paciente.direccion = @prmDireccion
		where Paciente.idPaciente = @prmIdPaciente
	end
GO
/****** Object:  StoredProcedure [dbo].[spActualizarHorarioAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarHorarioAtencion]
(@prmIdMedico int,
 @prmIdHorario int,
 @prmFecha datetime,
 @prmHora varchar(5)
)
AS
	BEGIN
		DECLARE @idHora int;

		SET @idHora = (SELECT H.idHora FROM Hora  H WHERE H.hora = RTRIM(@prmHora));

		UPDATE HA
		SET HA.fecha = @prmFecha,
		    HA.idHoraInicio = @idHora
		FROM HorarioAtencion HA
		WHERE HA.idHorarioAtencion = @prmIdHorario
		AND HA.idMedico = @prmIdMedico
		
	END
GO
/****** Object:  StoredProcedure [dbo].[spBuscarMedico]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarMedico] 
(@prmDni varchar(8))
AS
	BEGIN
		SELECT M.idMedico
			 , E.idEmpleado
			 , E.nombres as nombre
			 , E.apPaterno
			 , E.apMaterno
			 , ES.idEspecialidad
			 , ES.descripcion
			 , M.estado as estadoMedico
		FROM Medico M 
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN Especialidad ES ON (M.idEspecialidad = ES.idEspecialidad)
		WHERE M.estado = 1
		AND E.nroDocumento = @prmDni
	END
GO
/****** Object:  StoredProcedure [dbo].[spBuscarPacienteDNI]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarPacienteDNI]
(@prmDni varchar(10)
)
AS
	BEGIN
		SELECT P.idPaciente
		     , P.nombres AS Nombres
			 , P.apPaterno AS ApPaterno
			 , P.apMaterno AS ApMaterno
			 , P.telefono AS Telefono
			 , P.edad AS Edad
			 , P.sexo AS Sexo
		FROM Paciente P
		WHERE nroDocumento = @prmDni
	END
GO
/****** Object:  StoredProcedure [dbo].[spEditarHorarioAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEditarHorarioAtencion]
( @prmIdHorarioAtencion int,
  @prmIdMedico int,
  @prmFecha datetime,
  @prmHora varchar(6)
)
AS
	BEGIN
		DECLARE @idHora int;
		SET @idHora = (SELECT idHora FROM Hora WHERE hora =  RTRIM(@prmHora));
	
		UPDATE HA
		SET HA.fecha = @prmFecha,
		    HA.idHoraInicio = @idHora
		FROM HorarioAtencion HA 
		JOIN Hora H ON (HA.idHoraInicio = H.idHora)
		WHERE H.idHora = @idHora
		AND HA.idHorarioAtencion = @prmIdHorarioAtencion
		AND HA.idMedico = @prmIdMedico
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarHorarioAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarHorarioAtencion]
( @prmIdHorarioAtencion int
)
AS
	BEGIN
		UPDATE HorarioAtencion
		SET estado = 0
		WHERE idHorarioAtencion = @prmIdHorarioAtencion
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarPaciente]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarPaciente]
(@prmIdPaciente int)
AS
	BEGIN
		UPDATE Paciente
		SET estado = 0
		WHERE idPaciente = @prmIdPaciente
	END
GO
/****** Object:  StoredProcedure [dbo].[spListaHorariosAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListaHorariosAtencion]
(@prmIdMedico int
)
AS
	BEGIN
		SELECT M.idMedico, HA.idHorarioAtencion, HA.fecha, H.hora
		FROM Medico M
		INNER JOIN HorarioAtencion HA ON (M.idMedico = HA.idMedico)
		INNER JOIN Hora H ON (HA.idHoraInicio = H.idHora)
		WHERE M.idMedico = @prmIdMedico 
		AND CONVERT(VARCHAR(10), HA.fecha, 103) >= CONVERT(VARCHAR(10), GETDATE(), 103)
		AND HA.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarEspecialidades]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarEspecialidades]
AS
	BEGIN
		SELECT E.idEspecialidad, E.descripcion
		FROM Especialidad E
		WHERE E.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarHorariosAtencionPorFecha]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarHorariosAtencionPorFecha]
( @prmIdEspecialidad INT,
  @prmFecha DATE
)
AS
	BEGIN
		SELECT HA.idHorarioAtencion, HA.fecha, M.idMedico, E.nombres, H.idHora, H.hora
		FROM HorarioAtencion HA 
		INNER JOIN Medico M ON (HA.idMedico = M.idMedico)
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN Hora H ON (HA.idHoraInicio = H.idHora)
		WHERE CAST(HA.fecha AS DATE) = @prmFecha 
		AND M.idEspecialidad = @prmIdEspecialidad
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarPacientes]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarPacientes]
AS
	BEGIN
		SELECT P.idPaciente
		     , P.nombres
			 , P.apPaterno
			 , P.apMaterno
			 , P.edad
			 , P.sexo
			 , P.nroDocumento
			 , P.direccion
		FROM Paciente P
		WHERE P.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spRegistrarHorarioAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarHorarioAtencion]
(@prmIdMedico int,
 @prmHora varchar(5),
 @prmFecha datetime
)
AS
	BEGIN
		-- TRY CATCH
		BEGIN TRY
			DECLARE @hora int;
			DECLARE @idHorarioAtencion int;
			
			-- OBTENER EL ID RESPECTIVO DEL PARAMETRO HORA
			SET @hora = (SELECT H.idHora FROM Hora H WHERE H.hora = @prmHora);
						
			-- INSERT
			INSERT INTO HorarioATencion(idMedico, fecha, idHoraInicio, estado)
			VALUES(@prmIdMedico, @prmFecha, @hora, 1); 
			
			-- OBTENER EL ULTIMO REGISTRO INSERTADO EN LA TABLA HORARIOATENCION
			SET @idHorarioAtencion = SCOPE_IDENTITY();

			-- SELECT
			SELECT HA.idHorarioAtencion, HA.fecha, H.idHora, H.hora, HA.estado
			FROM HorarioAtencion HA
			INNER JOIN Hora H ON(HA.idHoraInicio = H.idHora)
			WHERE HA.idHorarioAtencion = @idHorarioAtencion
		END TRY
		BEGIN CATCH
			ROLLBACK;
			-- RAISERROR('',,,,'')
			-- PRINT 'mensaje'
		END CATCH
	END
GO
/****** Object:  StoredProcedure [dbo].[spRegistrarPaciente]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarPaciente]
(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEdad INT,
@prmSexo CHAR(1),
@prmNroDoc VARCHAR(8), 
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(20),
@prmEstado bit
)
AS
	BEGIN
		INSERT INTO Paciente(nombres, apPaterno, apMaterno, edad, sexo, nroDocumento, direccion, telefono, estado)
		VALUES(@prmNombres, @prmApPaterno, @prmApMaterno, @prmEdad, @prmSexo, @prmNroDoc, @prmDireccion, @prmTelefono, @prmEstado);
	END
GO
/****** Object:  Table [dbo].[Aseguradora]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Aseguradora](
	[idAseguradora] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](30) NULL,
	[telefono] [varchar](12) NULL,
	[direccion] [varchar](120) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Aseguradora] PRIMARY KEY CLUSTERED 
(
	[idAseguradora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cita]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cita](
	[idCita] [int] IDENTITY(1,1) NOT NULL,
	[idMedico] [int] NOT NULL,
	[idPaciente] [int] NOT NULL,
	[fechaReserva] [datetime] NULL,
	[observacion] [varchar](350) NULL,
	[estado] [char](1) NULL,
	[hora] [varchar](6) NULL,
 CONSTRAINT [PK_Cita] PRIMARY KEY CLUSTERED 
(
	[idCita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DetalleAseguradora]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetalleAseguradora](
	[idDetAseguradora] [int] IDENTITY(1,1) NOT NULL,
	[idAseguradora] [int] NULL,
	[idPaciente] [int] NULL,
	[tipoSeguroSalud] [varchar](50) NULL,
	[estado] [char](1) NULL,
 CONSTRAINT [PK_DetalleAseguradora] PRIMARY KEY CLUSTERED 
(
	[idDetAseguradora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Diagnostico]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Diagnostico](
	[idDiagnostico] [int] IDENTITY(1,1) NOT NULL,
	[idHistoriaClinica] [int] NOT NULL,
	[fechaEmision] [datetime] NULL,
	[observacion] [varchar](500) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Diagnostico] PRIMARY KEY CLUSTERED 
(
	[idDiagnostico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DiaSemana]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DiaSemana](
	[idDiaSemana] [int] IDENTITY(1,1) NOT NULL,
	[nombreDiaSemana] [varchar](50) NULL,
 CONSTRAINT [PK_DiaSemana] PRIMARY KEY CLUSTERED 
(
	[idDiaSemana] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Empleado](
	[idEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[idTipoEmpleado] [int] NOT NULL,
	[nombres] [varchar](50) NULL,
	[apPaterno] [varchar](20) NULL,
	[apMaterno] [varchar](20) NULL,
	[nroDocumento] [varchar](8) NULL,
	[estado] [bit] NULL,
	[imagen] [varchar](500) NULL,
	[usuario] [varchar](50) NULL,
	[clave] [varchar](50) NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[idEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Especialidad]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Especialidad](
	[idEspecialidad] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](25) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Especialidad] PRIMARY KEY CLUSTERED 
(
	[idEspecialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistoriaClinica]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoriaClinica](
	[idHistoriaClinica] [int] IDENTITY(1,1) NOT NULL,
	[idPaciente] [int] NULL,
	[fechaApertura] [datetime] NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_HistoriaClinica] PRIMARY KEY CLUSTERED 
(
	[idHistoriaClinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Hora]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hora](
	[idHora] [int] IDENTITY(1,1) NOT NULL,
	[hora] [varchar](6) NULL,
 CONSTRAINT [PK_Hora] PRIMARY KEY CLUSTERED 
(
	[idHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HorarioAtencion]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HorarioAtencion](
	[idHorarioAtencion] [int] IDENTITY(1,1) NOT NULL,
	[idMedico] [int] NOT NULL,
	[idHoraInicio] [int] NOT NULL,
	[fecha] [datetime] NULL,
	[fechaFin] [date] NULL,
	[estado] [bit] NULL,
	[idDiaSemana] [int] NULL,
 CONSTRAINT [PK_HorarioAtencion] PRIMARY KEY CLUSTERED 
(
	[idHorarioAtencion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Medico]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medico](
	[idMedico] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idEspecialidad] [int] NOT NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Medico] PRIMARY KEY CLUSTERED 
(
	[idMedico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Paciente]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Paciente](
	[idPaciente] [int] IDENTITY(1,1) NOT NULL,
	[nombres] [varchar](50) NULL,
	[apPaterno] [varchar](20) NULL,
	[apMaterno] [varchar](20) NULL,
	[edad] [int] NULL,
	[sexo] [char](1) NULL,
	[nroDocumento] [varchar](8) NULL,
	[direccion] [varchar](150) NULL,
	[telefono] [varchar](20) NULL,
	[estado] [bit] NULL,
	[imagen] [varchar](500) NULL,
 CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED 
(
	[idPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Prestamos]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Prestamos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPersona] [char](8) NULL,
	[montoSolicitado] [money] NULL,
	[fechaProceso] [datetime] NULL,
 CONSTRAINT [PK_Prestamos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoEmpleado]    Script Date: 29/01/2018 12:15:33 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoEmpleado](
	[idTipoEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](25) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_TipoEmpleado] PRIMARY KEY CLUSTERED 
(
	[idTipoEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Cita] ON 

INSERT [dbo].[Cita] ([idCita], [idMedico], [idPaciente], [fechaReserva], [observacion], [estado], [hora]) VALUES (14, 1, 1, CAST(N'2014-02-12 00:00:00.000' AS DateTime), N'', N'A', N'20:00')
INSERT [dbo].[Cita] ([idCita], [idMedico], [idPaciente], [fechaReserva], [observacion], [estado], [hora]) VALUES (15, 8, 1, CAST(N'2014-04-12 00:00:00.000' AS DateTime), N'', N'P', N'10:00')
INSERT [dbo].[Cita] ([idCita], [idMedico], [idPaciente], [fechaReserva], [observacion], [estado], [hora]) VALUES (16, 5, 1, CAST(N'2014-06-12 00:00:00.000' AS DateTime), N'', N'A', N'11:00')
SET IDENTITY_INSERT [dbo].[Cita] OFF
SET IDENTITY_INSERT [dbo].[Diagnostico] ON 

INSERT [dbo].[Diagnostico] ([idDiagnostico], [idHistoriaClinica], [fechaEmision], [observacion], [estado]) VALUES (3, 1, CAST(N'2014-11-11 22:19:24.630' AS DateTime), N'Dolores Lumbares, etc.', 1)
INSERT [dbo].[Diagnostico] ([idDiagnostico], [idHistoriaClinica], [fechaEmision], [observacion], [estado]) VALUES (6, 2, CAST(N'2014-11-11 22:51:12.110' AS DateTime), N'Infección en la pierna por un corte con vidrio.', 1)
INSERT [dbo].[Diagnostico] ([idDiagnostico], [idHistoriaClinica], [fechaEmision], [observacion], [estado]) VALUES (10, 3, CAST(N'2014-02-12 23:04:21.130' AS DateTime), N'Infección', 1)
INSERT [dbo].[Diagnostico] ([idDiagnostico], [idHistoriaClinica], [fechaEmision], [observacion], [estado]) VALUES (11, 3, CAST(N'2014-06-12 17:59:10.213' AS DateTime), N'sdfsdfsfsfsfsfsfd', 1)
SET IDENTITY_INSERT [dbo].[Diagnostico] OFF
SET IDENTITY_INSERT [dbo].[Empleado] ON 

INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (1, 1, N'Juan Carlos', N'Farias', N'Villegas', N'87653021', 1, NULL, N'jcfv', N'123')
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (2, 1, N'Rosa Maria', N'Flores', N'Linares', N'78650932', 1, NULL, N'rmfl', N'123')
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (3, 1, N'Carlos Jose', N'Romero', N'Alfaro', N'70983262', 1, NULL, N'cjra', N'123')
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (4, 3, N'Jorge Junior', N'Rodriguez', N'Castillo', N'70874378', 1, NULL, N'jjrc', N'admin')
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (5, 1, N'Felicita Sara', N'Abarca', N'Heredia', N'17070167', 1, NULL, N'fsah', N'123')
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (6, 1, N'Maria Isabel', N'Acuña', N'Chumpitaz', N'16060198', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (7, 1, N'Flor Beatriz', N'Alarcon', N'Samame', N'86572102', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (8, 1, N'Diego Carlos', N'Aquino', N'Mendez', N'14040149', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (9, 1, N'Ronald Josue', N'Pareja', N'Alvarez', N'73030139', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (10, 1, N'Jaime Raul', N'Arca', N'Rodriguez', N'66020229', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (11, 1, N'Jose Victor', N'Arias', N'Figueroa', N'58780564', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (12, 1, N'Jhon Luis', N'Alfaro', N'Ganoza', N'87690432', 1, NULL, NULL, NULL)
INSERT [dbo].[Empleado] ([idEmpleado], [idTipoEmpleado], [nombres], [apPaterno], [apMaterno], [nroDocumento], [estado], [imagen], [usuario], [clave]) VALUES (13, 1, N'Default User', N'Default', N'User', N'99007722', 1, NULL, N'prueba', N'prueba')
SET IDENTITY_INSERT [dbo].[Empleado] OFF
SET IDENTITY_INSERT [dbo].[Especialidad] ON 

INSERT [dbo].[Especialidad] ([idEspecialidad], [descripcion], [estado]) VALUES (1, N'Medico General', 1)
INSERT [dbo].[Especialidad] ([idEspecialidad], [descripcion], [estado]) VALUES (2, N'Pediatra', 1)
INSERT [dbo].[Especialidad] ([idEspecialidad], [descripcion], [estado]) VALUES (3, N'Traumatologo', 1)
INSERT [dbo].[Especialidad] ([idEspecialidad], [descripcion], [estado]) VALUES (4, N'Oftalmologo', 1)
SET IDENTITY_INSERT [dbo].[Especialidad] OFF
SET IDENTITY_INSERT [dbo].[HistoriaClinica] ON 

INSERT [dbo].[HistoriaClinica] ([idHistoriaClinica], [idPaciente], [fechaApertura], [estado]) VALUES (1, 3, CAST(N'2014-11-11 22:15:48.800' AS DateTime), 1)
INSERT [dbo].[HistoriaClinica] ([idHistoriaClinica], [idPaciente], [fechaApertura], [estado]) VALUES (2, 2, CAST(N'2014-11-11 22:42:01.727' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[HistoriaClinica] OFF
SET IDENTITY_INSERT [dbo].[Hora] ON 

INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (1, N'09:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (2, N'09:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (3, N'10:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (4, N'10:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (5, N'11:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (6, N'11:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (7, N'12:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (8, N'15:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (9, N'15:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (10, N'16:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (11, N'16:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (12, N'17:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (13, N'17:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (14, N'18:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (15, N'18:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (16, N'19:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (17, N'19:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (18, N'20:00')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (19, N'20:30')
INSERT [dbo].[Hora] ([idHora], [hora]) VALUES (20, N'21:00')
SET IDENTITY_INSERT [dbo].[Hora] OFF
SET IDENTITY_INSERT [dbo].[HorarioAtencion] ON 

INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (1, 6, 10, CAST(N'2017-07-02 00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (2, 6, 13, CAST(N'2017-07-02 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (3, 6, 1, CAST(N'2017-07-03 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (4, 6, 5, CAST(N'2017-07-03 00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (1002, 7, 1, CAST(N'2017-10-15 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (1003, 7, 1, CAST(N'2017-10-15 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (1004, 7, 2, CAST(N'2017-10-15 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (1005, 7, 3, CAST(N'2017-10-15 00:00:00.000' AS DateTime), NULL, 0, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (2002, 2, 2, CAST(N'2018-01-29 00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[HorarioAtencion] ([idHorarioAtencion], [idMedico], [idHoraInicio], [fecha], [fechaFin], [estado], [idDiaSemana]) VALUES (2003, 2, 3, CAST(N'2018-01-29 00:00:00.000' AS DateTime), NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[HorarioAtencion] OFF
SET IDENTITY_INSERT [dbo].[Medico] ON 

INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (1, 1, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (2, 3, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (3, 2, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (4, 5, 3, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (5, 6, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (6, 7, 3, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (7, 8, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (8, 9, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (9, 10, 1, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (10, 11, 4, 1)
INSERT [dbo].[Medico] ([idMedico], [idEmpleado], [idEspecialidad], [estado]) VALUES (21, 12, 4, 1)
SET IDENTITY_INSERT [dbo].[Medico] OFF
SET IDENTITY_INSERT [dbo].[Paciente] ON 

INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (1, N'Jorge Junior', N'Rodriguez', N'Castillo', 21, N'M', N'17887490', N'David Lozano #854 Urb. El Bosque', N'953696711', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (2, N'Sandra', N'Sanchez', N'Moreno', 20, N'F', N'87690987', N'El Molino #888', N'953489021', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (3, N'Francisco', N'Pereda', N'Sandoval', 32, N'M', N'70981274', N'El Porvenir', N'976534091', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (4, N'Javier Estefano', N'Sanchez', N'Martinez', 28, N'M', N'56743409', N'Urb. El Recreo #535', N'285746', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (5, N'Cesar Javier', N'Vasquez', N'Leon', 30, N'M', N'46783254', N'Av. America #9854', N'245684', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (6, N'Maria Isabel', N'Farias', N'Tirado', 25, N'F', N'24236789', N'Urb .El Recreo #765', N'346778', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (7, N'Carlos Andres', N'Paredes', N'Sisniegas', 32, N'M', N'76564909', N'Av. America #842', N'95786198', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (8, N'Jorge Junior', N'Rodriguez', N'Castillo', 21, N'M', N'78541203', N'Calle 128 ', N'96520140', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (9, N'Julia Maria', N'Santoso', N'Morales', 22, N'F', N'99632014', N'Sin dirección', N'625485', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (10, N'Julia Maria', N'Santoso', N'Morales', 21, N'F', N'78541203', N'Sin dirección', N'625485', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (11, N'Julia Maria', N'Santoso', N'Morales', 25, N'F', N'78541203', N'Sin dirección', N'625485', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (12, N'JJJ RRR', N'RR', N'CC', 23, N'M', N'3456789', N'Sin dirección', N'625485', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (13, N'24', N'2', N'24', 24, N'M', N'2324', N'234', N'24', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (14, N'24', N'2', N'24', 24, N'M', N'2324', N'234', N'24', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (15, N'2434234', N'24243 2342', N'234', 24324, N'M', N'34', N'23424', N'242', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (16, N'sdsffsfs', N'Rodriguez', N'Morales', 22, N'M', N'78541203', N'Calle 128 ', N'96520140', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (17, N'ad', N'ad', N'as', 12, N'M', N'ad', N'a', N'ad', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (18, N'dssad', N'asdasd', N'asdads', 23, N'M', N'234234', N'sdsdfs', N'2332', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (19, N'dssad', N'asdasd', N'asdads', 23, N'M', N'234234', N'sdsdfs', N'2332', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (20, N'ssdsdf', N'asdasd', N'asdads', 23, N'M', N'234234', N'sdsdfs', N'2222', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (21, N'JJJ RRR', N'Santoso', N'asfaf', 23, N'M', N'99632014', N'asdsasd', N'3453', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (23, N'xtyyjyj', N'ttyytty', N'tyhytyt', 11, N'F', N'867555', N'sfddgf6565b', N'3455675', 0, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (24, N'adasd asdasd', N'asdasd', N'asd', 12, N'M', N'1232131', N'12dasdasd', N'asdasd123', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (25, N'dsad asdasd', N'asdasd', N'asdasd', 23, N'M', N'234234', N'sdsdsdf', N'23423424', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (26, N'dsad asdasd', N'asdasd', N'asdasd', 23, N'M', N'22222', N'sdsdsdf', N'23423424', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (27, N'Alejandro', N'Cruzado', N'Rodriguez', 19, N'F', N'99662210', N'David Lozano #8852', N'632015', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (28, N'asdasdasd', N'asdasdads', N'asdasdsad', 19, N'M', N'93662210', N'Los Caballeros #585', N'23424234', 1, NULL)
INSERT [dbo].[Paciente] ([idPaciente], [nombres], [apPaterno], [apMaterno], [edad], [sexo], [nroDocumento], [direccion], [telefono], [estado], [imagen]) VALUES (29, N'alejandro alejandro', N'asdasdads', N'asdasdsad', 19, N'M', N'93662210', N'asdasdasd', N'23424234', 0, NULL)
SET IDENTITY_INSERT [dbo].[Paciente] OFF
SET IDENTITY_INSERT [dbo].[Prestamos] ON 

INSERT [dbo].[Prestamos] ([id], [idPersona], [montoSolicitado], [fechaProceso]) VALUES (3, N'0085214 ', 8500.0000, CAST(N'2015-05-06 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Prestamos] OFF
SET IDENTITY_INSERT [dbo].[TipoEmpleado] ON 

INSERT [dbo].[TipoEmpleado] ([idTipoEmpleado], [descripcion], [estado]) VALUES (1, N'Medico', 1)
INSERT [dbo].[TipoEmpleado] ([idTipoEmpleado], [descripcion], [estado]) VALUES (2, N'Secretaria', 1)
INSERT [dbo].[TipoEmpleado] ([idTipoEmpleado], [descripcion], [estado]) VALUES (3, N'Administrador', 1)
SET IDENTITY_INSERT [dbo].[TipoEmpleado] OFF
ALTER TABLE [dbo].[Cita]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
ALTER TABLE [dbo].[Cita] CHECK CONSTRAINT [FK_Cita_Medico]
GO
ALTER TABLE [dbo].[Cita]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[Paciente] ([idPaciente])
GO
ALTER TABLE [dbo].[Cita] CHECK CONSTRAINT [FK_Cita_Paciente]
GO
ALTER TABLE [dbo].[DetalleAseguradora]  WITH CHECK ADD  CONSTRAINT [FK_DetalleAseguradora_Aseguradora] FOREIGN KEY([idAseguradora])
REFERENCES [dbo].[Aseguradora] ([idAseguradora])
GO
ALTER TABLE [dbo].[DetalleAseguradora] CHECK CONSTRAINT [FK_DetalleAseguradora_Aseguradora]
GO
ALTER TABLE [dbo].[DetalleAseguradora]  WITH CHECK ADD  CONSTRAINT [FK_DetalleAseguradora_Paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[Paciente] ([idPaciente])
GO
ALTER TABLE [dbo].[DetalleAseguradora] CHECK CONSTRAINT [FK_DetalleAseguradora_Paciente]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_TipoEmpleado] FOREIGN KEY([idTipoEmpleado])
REFERENCES [dbo].[TipoEmpleado] ([idTipoEmpleado])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_TipoEmpleado]
GO
ALTER TABLE [dbo].[HistoriaClinica]  WITH CHECK ADD  CONSTRAINT [FK_HistoriaClinica_Paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[Paciente] ([idPaciente])
GO
ALTER TABLE [dbo].[HistoriaClinica] CHECK CONSTRAINT [FK_HistoriaClinica_Paciente]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_DiaSemana] FOREIGN KEY([idDiaSemana])
REFERENCES [dbo].[DiaSemana] ([idDiaSemana])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_DiaSemana]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_Hora] FOREIGN KEY([idHoraInicio])
REFERENCES [dbo].[Hora] ([idHora])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_Hora]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_Medico]
GO
ALTER TABLE [dbo].[Medico]  WITH CHECK ADD  CONSTRAINT [FK_Medico_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([idEmpleado])
GO
ALTER TABLE [dbo].[Medico] CHECK CONSTRAINT [FK_Medico_Empleado]
GO
ALTER TABLE [dbo].[Medico]  WITH CHECK ADD  CONSTRAINT [FK_Medico_Especialidad] FOREIGN KEY([idEspecialidad])
REFERENCES [dbo].[Especialidad] ([idEspecialidad])
GO
ALTER TABLE [dbo].[Medico] CHECK CONSTRAINT [FK_Medico_Especialidad]
GO
