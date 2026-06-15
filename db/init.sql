/* =========================================
   1. CREAR BASE DE DATOS
========================================= */
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Barberia360')
BEGIN
    CREATE DATABASE Barberia360;
END
GO

USE Barberia360;
GO


/* =========================================
   2. TABLA PERSON
========================================= */
IF OBJECT_ID('dbo.Person', 'U') IS NOT NULL
    DROP TABLE dbo.Person;
GO

CREATE TABLE dbo.Person (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Identification VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    DeletedAt DATETIME NULL
);
GO


/* =========================================
   3. TABLA USERS
========================================= */
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    PasswordHash NVARCHAR(256),
    Role NVARCHAR(20),
    Phone NVARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO


/* =========================================
   4. HISTORIAL PERSON
========================================= */
IF OBJECT_ID('dbo.PersonHistory', 'U') IS NOT NULL
    DROP TABLE dbo.PersonHistory;
GO

CREATE TABLE dbo.PersonHistory (
    HistoryId INT IDENTITY(1,1) PRIMARY KEY,
    PersonId INT,
    ActionType VARCHAR(20),
    OldData NVARCHAR(MAX),
    NewData NVARCHAR(MAX),
    ActionDate DATETIME DEFAULT GETDATE()
);
GO


/* =========================================
   5. INDICES
========================================= */
CREATE INDEX IX_Person_Email ON Person(Email);
CREATE INDEX IX_Person_IsDeleted ON Person(IsDeleted);
GO


/* =========================================
   6. STORED PROCEDURES PERSON
========================================= */

CREATE OR ALTER PROCEDURE dbo.sp_CreatePerson
    @pn_Identification VARCHAR(50),
    @pn_Name VARCHAR(100),
    @pn_Email VARCHAR(100),
    @pd_BirthDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Person (Identification, Name, Email, BirthDate)
    VALUES (@pn_Identification, @pn_Name, @pn_Email, @pd_BirthDate);

    DECLARE @NewId INT = SCOPE_IDENTITY();

    INSERT INTO PersonHistory (PersonId, ActionType, NewData)
    VALUES (@NewId, 'INSERT',
        CONCAT(@pn_Identification,'|',@pn_Name,'|',@pn_Email)
    );

    SELECT @NewId AS NewId;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_GetAllPersons
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Person WHERE IsDeleted = 0;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_GetPersonById
    @pi_Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Person WHERE Id = @pi_Id AND IsDeleted = 0;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_UpdatePerson
    @pi_Id INT,
    @pn_Identification VARCHAR(50),
    @pn_Name VARCHAR(100),
    @pn_Email VARCHAR(100),
    @pd_BirthDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldData NVARCHAR(MAX);

    SELECT @OldData = CONCAT(Identification,'|',Name,'|',Email)
    FROM Person WHERE Id = @pi_Id;

    UPDATE Person
    SET 
        Identification = @pn_Identification,
        Name = @pn_Name,
        Email = @pn_Email,
        BirthDate = @pd_BirthDate,
        UpdatedAt = GETDATE()
    WHERE Id = @pi_Id AND IsDeleted = 0;

    INSERT INTO PersonHistory (PersonId, ActionType, OldData, NewData)
    VALUES (
        @pi_Id,
        'UPDATE',
        @OldData,
        CONCAT(@pn_Identification,'|',@pn_Name,'|',@pn_Email)
    );

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_DeletePerson
    @pi_Id INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldData NVARCHAR(MAX);

    SELECT @OldData = CONCAT(Identification,'|',Name,'|',Email)
    FROM Person WHERE Id = @pi_Id;

    UPDATE Person
    SET 
        IsDeleted = 1,
        DeletedAt = GETDATE()
    WHERE Id = @pi_Id AND IsDeleted = 0;

    INSERT INTO PersonHistory (PersonId, ActionType, OldData)
    VALUES (@pi_Id, 'DELETE', @OldData);

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO


/* =========================================
   7. STORED PROCEDURES USERS 
========================================= */

CREATE OR ALTER PROCEDURE dbo.sp_CreateUser
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(256),
    @Role NVARCHAR(20),
    @Phone NVARCHAR(20) = NULL,
    @UserId INT OUTPUT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
        BEGIN
            SET @Success = 0;
            SET @Message = 'El email ya est  registrado';
            SET @UserId = 0;
            RETURN;
        END

        INSERT INTO Users (Name, Email, PasswordHash, Role, Phone)
        VALUES (@Name, @Email, @PasswordHash, @Role, @Phone);
        
        SET @UserId = SCOPE_IDENTITY();
        SET @Success = 1;
        SET @Message = 'Usuario creado exitosamente';
        
    END TRY
    BEGIN CATCH
        SET @Success = 0;
        SET @Message = ERROR_MESSAGE();
        SET @UserId = 0;
    END CATCH
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_GetUserByEmail
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        UserId,
        Name,
        Email,
        PasswordHash,
        Role,
        Phone,
        CreatedAt
    FROM Users
    WHERE Email = @Email;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_Users_GetAll
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UserId, Name, Email, Role, Phone, CreatedAt
    FROM Users
    ORDER BY Name;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_Users_Maintenance
    @Action NVARCHAR(10),
    @UserId INT = NULL,
    @Name NVARCHAR(100) = NULL,
    @Email NVARCHAR(100) = NULL,
    @PasswordHash NVARCHAR(256) = NULL,
    @Role NVARCHAR(20) = NULL,
    @Phone NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO Users (Name, Email, PasswordHash, Role, Phone, CreatedAt)
        VALUES (@Name, @Email, @PasswordHash, @Role, @Phone, GETDATE());

        SELECT SCOPE_IDENTITY() AS NewUserId;
    END
    ELSE IF @Action = 'UPDATE'
    BEGIN
        UPDATE Users
        SET Name = @Name,
            Email = @Email,
            PasswordHash = @PasswordHash,
            Role = @Role,
            Phone = @Phone
        WHERE UserId = @UserId;

        SELECT @@ROWCOUNT AS RowsAffected;
    END
    ELSE IF @Action = 'DELETE'
    BEGIN
        DELETE FROM Users WHERE UserId = @UserId;

        SELECT @@ROWCOUNT AS RowsAffected;
    END
    ELSE
    BEGIN
        RAISERROR('Acci n no v lida.', 16, 1);
    END
END
GO


/* =========================================
   8. DATOS DE PRUEBA
========================================= */
IF NOT EXISTS (SELECT 1 FROM Person)
BEGIN
INSERT INTO Person (Identification, Name, Email, BirthDate)
VALUES 
('101234567', 'Luis Fernando Rodríguez Mora', 'lrodriguez@gmail.com', '1989-07-14'),
('102345678', 'Ana Gabriela Sánchez López', 'ana.sanchez@hotmail.com', '1994-11-22'),
('103456789', 'Carlos Andrés Villalobos Rojas', 'carlos.villalobos@yahoo.com', '1987-03-09'),
('104567890', 'María José Hernández Castro', 'mariajose.hc@gmail.com', '1998-01-30'),
('105678901', 'Daniel Alberto Pérez Vargas', 'daniel.perez@outlook.com', '1992-06-18'),
('106789012', 'Sofía Valeria Jiménez Solano', 'sofia.jimenez@gmail.com', '2000-09-25'),
('107890123', 'José Manuel Ramírez Gómez', 'jramirez@hotmail.com', '1985-12-05'),
('108901234', 'Gabriela Fernández Quesada', 'gabriela.fq@yahoo.com', '1997-04-11');

END

GO