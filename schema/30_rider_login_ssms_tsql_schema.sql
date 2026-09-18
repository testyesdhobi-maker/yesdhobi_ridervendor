/*=============================================================================
  YES DHOBI - RIDER LOGIN / AUTHENTICATION SCHEMA (SSMS / SQL Server Fix)
  Fix for: Msg 207 "Invalid column name 'IsSelfieVerified'"
=============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-- ============================================================================
-- 1. ENSURE ALL REQUIRED COLUMNS EXIST ON dbo.RiderRegistrations
-- ============================================================================
IF OBJECT_ID(N'dbo.RiderRegistrations', N'U') IS NULL
BEGIN
    RAISERROR('Table dbo.RiderRegistrations does not exist. Please create it first.', 16, 1);
    RETURN;
END;
GO

-- Add IsSelfieVerified if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'IsSelfieVerified') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD IsSelfieVerified BIT NOT NULL CONSTRAINT DF_RiderRegistrations_IsSelfieVerified DEFAULT 0;
END;
GO

-- Add IsOnline if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'IsOnline') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD IsOnline BIT NOT NULL CONSTRAINT DF_RiderRegistrations_IsOnline DEFAULT 0;
END;
GO

-- Add IsActive if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'IsActive') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD IsActive BIT NOT NULL CONSTRAINT DF_RiderRegistrations_IsActive DEFAULT 1;
END;
GO

-- Add LastSelfieUrl if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'LastSelfieUrl') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD LastSelfieUrl NVARCHAR(MAX) NULL;
END;
GO

-- Add FailedLoginCount if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'FailedLoginCount') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD FailedLoginCount INT NOT NULL CONSTRAINT DF_RiderRegistrations_FailedLoginCount DEFAULT 0;
END;
GO

-- Add LockedUntil if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'LockedUntil') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD LockedUntil DATETIME2(7) NULL;
END;
GO

-- Add LastLoginAt if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'LastLoginAt') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD LastLoginAt DATETIME2(7) NULL;
END;
GO

-- Add PasswordChangedAt if missing
IF COL_LENGTH(N'dbo.RiderRegistrations', N'PasswordChangedAt') IS NULL
BEGIN
    ALTER TABLE dbo.RiderRegistrations 
    ADD PasswordChangedAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderRegistrations_PasswordChangedAt DEFAULT SYSUTCDATETIME();
END;
GO


-- ============================================================================
-- 2. RIDER DEVICES TABLE (FCM / APNS Push Tokens)
-- ============================================================================
IF OBJECT_ID(N'dbo.RiderDevices', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RiderDevices
    (
        Id UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_RiderDevices_Id DEFAULT NEWSEQUENTIALID(),
        RiderId UNIQUEIDENTIFIER NOT NULL,
        DeviceToken NVARCHAR(512) NOT NULL,
        Platform VARCHAR(10) NOT NULL,
        DeviceName NVARCHAR(150) NULL,
        AppVersion NVARCHAR(30) NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_RiderDevices_IsActive DEFAULT (1),
        LastSeenAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderDevices_LastSeenAt DEFAULT SYSUTCDATETIME(),
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderDevices_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderDevices_UpdatedAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_RiderDevices PRIMARY KEY CLUSTERED (Id),
        CONSTRAINT FK_RiderDevices_RiderRegistrations FOREIGN KEY (RiderId)
            REFERENCES dbo.RiderRegistrations(Id) ON DELETE CASCADE,
        CONSTRAINT UQ_RiderDevices_DeviceToken UNIQUE (DeviceToken),
        CONSTRAINT CHK_RiderDevices_Platform CHECK (Platform IN ('android', 'ios'))
    );
END;
GO

-- ============================================================================
-- 3. RIDER AUTH SESSIONS TABLE (Refresh Token Hashes)
-- ============================================================================
IF OBJECT_ID(N'dbo.RiderAuthSessions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RiderAuthSessions
    (
        Id UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_RiderAuthSessions_Id DEFAULT NEWSEQUENTIALID(),
        RiderId UNIQUEIDENTIFIER NOT NULL,
        DeviceId UNIQUEIDENTIFIER NULL,
        RefreshTokenHash BINARY(32) NOT NULL,
        RefreshTokenExpiresAt DATETIME2(7) NOT NULL,
        IpAddress VARCHAR(45) NULL,
        UserAgent NVARCHAR(500) NULL,
        CreatedAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderAuthSessions_CreatedAt DEFAULT SYSUTCDATETIME(),
        LastUsedAt DATETIME2(7) NULL,
        RevokedAt DATETIME2(7) NULL,
        RevokeReason NVARCHAR(200) NULL,
        ReplacedBySessionId UNIQUEIDENTIFIER NULL,
        CONSTRAINT PK_RiderAuthSessions PRIMARY KEY CLUSTERED (Id),
        CONSTRAINT FK_RiderAuthSessions_RiderRegistrations FOREIGN KEY (RiderId)
            REFERENCES dbo.RiderRegistrations(Id) ON DELETE CASCADE,
        CONSTRAINT FK_RiderAuthSessions_RiderDevices FOREIGN KEY (DeviceId)
            REFERENCES dbo.RiderDevices(Id),
        CONSTRAINT FK_RiderAuthSessions_ReplacedBy FOREIGN KEY (ReplacedBySessionId)
            REFERENCES dbo.RiderAuthSessions(Id),
        CONSTRAINT UQ_RiderAuthSessions_RefreshTokenHash UNIQUE (RefreshTokenHash),
        CONSTRAINT CHK_RiderAuthSessions_Expiry CHECK (RefreshTokenExpiresAt > CreatedAt),
        CONSTRAINT CHK_RiderAuthSessions_Revocation CHECK
            ((RevokedAt IS NULL AND RevokeReason IS NULL) OR RevokedAt IS NOT NULL)
    );
END;
GO

-- ============================================================================
-- 4. RIDER LOGIN ATTEMPTS AUDIT TABLE
-- ============================================================================
IF OBJECT_ID(N'dbo.RiderLoginAttempts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RiderLoginAttempts
    (
        Id BIGINT IDENTITY(1,1) NOT NULL,
        RiderId UNIQUEIDENTIFIER NULL,
        MobileNumber NVARCHAR(15) NOT NULL,
        WasSuccessful BIT NOT NULL,
        FailureReason VARCHAR(40) NULL,
        IpAddress VARCHAR(45) NULL,
        UserAgent NVARCHAR(500) NULL,
        AttemptedAt DATETIME2(7) NOT NULL CONSTRAINT DF_RiderLoginAttempts_AttemptedAt DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_RiderLoginAttempts PRIMARY KEY CLUSTERED (Id),
        CONSTRAINT FK_RiderLoginAttempts_RiderRegistrations FOREIGN KEY (RiderId)
            REFERENCES dbo.RiderRegistrations(Id),
        CONSTRAINT CHK_RiderLoginAttempts_Mobile CHECK
            (MobileNumber LIKE '[6-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
        CONSTRAINT CHK_RiderLoginAttempts_Result CHECK
            ((WasSuccessful = 1 AND FailureReason IS NULL) OR
             (WasSuccessful = 0 AND FailureReason IN
                ('INVALID_CREDENTIALS','NOT_APPROVED','NOT_VERIFIED','INACTIVE','LOCKED')))
    );
END;
GO

-- ============================================================================
-- 5. INDEXES
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_RiderAuthSessions_Rider_Active' AND object_id = OBJECT_ID(N'dbo.RiderAuthSessions'))
    CREATE INDEX IX_RiderAuthSessions_Rider_Active
        ON dbo.RiderAuthSessions (RiderId, RevokedAt, RefreshTokenExpiresAt DESC)
        INCLUDE (DeviceId, LastUsedAt);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_RiderLoginAttempts_Mobile_Time' AND object_id = OBJECT_ID(N'dbo.RiderLoginAttempts'))
    CREATE INDEX IX_RiderLoginAttempts_Mobile_Time
        ON dbo.RiderLoginAttempts (MobileNumber, AttemptedAt DESC)
        INCLUDE (WasSuccessful, FailureReason, IpAddress);
GO

-- ============================================================================
-- 6. STORED PROCEDURES
-- ============================================================================

-- Stored Procedure: Rider Login Lookup
CREATE OR ALTER PROCEDURE dbo.sp_RiderLoginLookup
    @MobileNumber NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    IF @MobileNumber NOT LIKE '[6-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        THROW 50002, 'Invalid mobile number format.', 1;

    SELECT Id, RiderCode, FullName, MobileNumber, Email, PasswordHash,
           ProfilePhotoUrl, OnboardingStatus, IsVerified, IsSelfieVerified,
           IsOnline, IsActive, FailedLoginCount, LockedUntil, PasswordChangedAt
    FROM dbo.RiderRegistrations
    WHERE MobileNumber = @MobileNumber;
END;
GO

-- Stored Procedure: Record Login Failure
CREATE OR ALTER PROCEDURE dbo.sp_RecordRiderLoginFailure
    @MobileNumber NVARCHAR(15),
    @FailureReason VARCHAR(40) = 'INVALID_CREDENTIALS',
    @IpAddress VARCHAR(45) = NULL,
    @UserAgent NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @RiderId UNIQUEIDENTIFIER;
    SELECT @RiderId = Id FROM dbo.RiderRegistrations WHERE MobileNumber = @MobileNumber;

    BEGIN TRANSACTION;
    IF @RiderId IS NOT NULL
    BEGIN
        UPDATE dbo.RiderRegistrations
        SET FailedLoginCount = FailedLoginCount + 1,
            LockedUntil = CASE WHEN FailedLoginCount + 1 >= 5
                               THEN DATEADD(MINUTE, 15, SYSUTCDATETIME())
                               ELSE LockedUntil END
        WHERE Id = @RiderId;
    END;
    INSERT dbo.RiderLoginAttempts
        (RiderId, MobileNumber, WasSuccessful, FailureReason, IpAddress, UserAgent)
    VALUES
        (@RiderId, @MobileNumber, 0, @FailureReason, @IpAddress, @UserAgent);
    COMMIT;
END;
GO

-- Stored Procedure: Create Rider Login Session
CREATE OR ALTER PROCEDURE dbo.sp_CreateRiderLoginSession
    @RiderId UNIQUEIDENTIFIER,
    @RefreshTokenHash BINARY(32),
    @RefreshTokenExpiresAt DATETIME2(7),
    @DeviceToken NVARCHAR(512) = NULL,
    @Platform VARCHAR(10) = NULL,
    @DeviceName NVARCHAR(150) = NULL,
    @AppVersion NVARCHAR(30) = NULL,
    @IpAddress VARCHAR(45) = NULL,
    @UserAgent NVARCHAR(500) = NULL,
    @SessionId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Now DATETIME2(7) = SYSUTCDATETIME(), @DeviceId UNIQUEIDENTIFIER = NULL;

    IF @RefreshTokenExpiresAt <= @Now THROW 50003, 'Refresh token expiry must be in the future.', 1;
    IF @DeviceToken IS NOT NULL AND @Platform NOT IN ('android','ios')
        THROW 50004, 'Platform must be android or ios when a device token is supplied.', 1;

    BEGIN TRANSACTION;
    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.RiderRegistrations WITH (UPDLOCK, HOLDLOCK)
        WHERE Id = @RiderId AND IsActive = 1 AND IsVerified = 1
          AND OnboardingStatus = 'APPROVED'
          AND (LockedUntil IS NULL OR LockedUntil <= @Now)
    )
        THROW 50005, 'Rider account cannot log in.', 1;

    IF @DeviceToken IS NOT NULL
    BEGIN
        SELECT @DeviceId = Id FROM dbo.RiderDevices WHERE DeviceToken = @DeviceToken;
        IF @DeviceId IS NULL
        BEGIN
            SET @DeviceId = NEWID();
            INSERT dbo.RiderDevices
                (Id, RiderId, DeviceToken, Platform, DeviceName, AppVersion)
            VALUES
                (@DeviceId, @RiderId, @DeviceToken, @Platform, @DeviceName, @AppVersion);
        END
        ELSE
            UPDATE dbo.RiderDevices
            SET RiderId = @RiderId, Platform = @Platform, DeviceName = @DeviceName,
                AppVersion = @AppVersion, IsActive = 1, LastSeenAt = @Now, UpdatedAt = @Now
            WHERE Id = @DeviceId;
    END;

    SET @SessionId = NEWID();
    INSERT dbo.RiderAuthSessions
        (Id, RiderId, DeviceId, RefreshTokenHash, RefreshTokenExpiresAt, IpAddress, UserAgent)
    VALUES
        (@SessionId, @RiderId, @DeviceId, @RefreshTokenHash, @RefreshTokenExpiresAt, @IpAddress, @UserAgent);

    UPDATE dbo.RiderRegistrations
    SET FailedLoginCount = 0, LockedUntil = NULL, LastLoginAt = @Now
    WHERE Id = @RiderId;

    INSERT dbo.RiderLoginAttempts
        (RiderId, MobileNumber, WasSuccessful, FailureReason, IpAddress, UserAgent)
    SELECT Id, MobileNumber, 1, NULL, @IpAddress, @UserAgent
    FROM dbo.RiderRegistrations WHERE Id = @RiderId;
    COMMIT;

    SELECT @SessionId AS SessionId, Id, RiderCode, FullName, MobileNumber, Email,
           ProfilePhotoUrl, OnboardingStatus, IsVerified, IsSelfieVerified, IsOnline
    FROM dbo.RiderRegistrations WHERE Id = @RiderId;
END;
GO

-- Stored Procedure: Revoke Session on Logout
CREATE OR ALTER PROCEDURE dbo.sp_RevokeRiderSession
    @SessionId UNIQUEIDENTIFIER,
    @RiderId UNIQUEIDENTIFIER,
    @Reason NVARCHAR(200) = N'LOGOUT'
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.RiderAuthSessions
    SET RevokedAt = COALESCE(RevokedAt, SYSUTCDATETIME()),
        RevokeReason = COALESCE(RevokeReason, @Reason)
    WHERE Id = @SessionId AND RiderId = @RiderId;
END;
GO
