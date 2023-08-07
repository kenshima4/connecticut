
-- Create the CompanyDatabase
USE master
GO

-- Drop Database Command
DROP DATABASE IF EXISTS CompanyDatabase
GO

-- SQL Create Database Command with default database files and properties
CREATE DATABASE CompanyDatabase
GO

-- Use the current database
USE CompanyDatabase -- Database Name
GO

-- Create the two main tables Companies and Employees
DROP TABLE IF EXISTS Clients;
GO

DROP TABLE IF EXISTS Contacts;
GO

DROP TABLE IF EXISTS ClientContacts;
GO

USE CompanyDatabase;
GO

SELECT
  *
FROM
  INFORMATION_SCHEMA.TABLES;
GO

CREATE OR ALTER PROCEDURE dbo.GetContacts -- CREATE PROCEDURE - contacts
AS
BEGIN
      SELECT [id]
            ,[Name]
            ,[Surname]
            ,[Email]
			,[NoLinkedClients]
			,[IsActive]
            ,[CreateDate]
      FROM [dbo].[Contacts]
END;
 
--To run the Stored Procedure you would run the following SQL code:
EXEC dbo.GetContacts;
GO

CREATE OR ALTER PROCEDURE dbo.GetClients -- CREATE PROCEDURE - clients
AS
BEGIN
      SELECT [id]
            ,[Name]
            ,[ClientCode]
            ,[NoLinkedContacts]
			,[IsActive]
            ,[CreateDate]
      FROM [dbo].[Clients]
END;
GO

--To run the Stored Procedure you would run the following SQL code:
EXEC dbo.GetClients;
GO

CREATE OR ALTER PROCEDURE dbo.GetClientCodes -- CREATE PROCEDURE - get client codes
AS
BEGIN
		SELECT [ClientCode]
		FROM [dbo].[Clients]
END;
GO

--To run the Stored Procedure you would run the following SQL code:
EXEC dbo.GetClients;
GO

CREATE OR ALTER PROCEDURE dbo.InsClient
    @Name  varchar(80), -- input parameters
    @ClientCode   varchar(80),
    @ID INT OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[Clients]
           ([Name]
           ,[ClientCode]
           ,[NoLinkedContacts]
           ,[CreateDate])
      VALUES
           (@Name
           ,@ClientCode
           ,0
           ,getdate());

    SET @ID = SCOPE_IDENTITY(); -- Get the newly inserted client's ID and set it to the output parameter
END;
GO

CREATE OR ALTER PROCEDURE dbo.InsContact
    @Name  varchar(80), -- input parameters
	@Surname  varchar(80),
	@Email varchar(80),
    @ID INT OUTPUT
AS
BEGIN
    -- Check if the email already exists in the Contacts table
    IF EXISTS (SELECT 1 FROM Contacts WHERE Email = @Email)
    BEGIN
        RAISERROR('Contact with the same email already exists.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Insert the contact into the Contacts table
        INSERT INTO [dbo].[Contacts]
           ([Name]
           ,[Surname]
           ,[Email]
		   ,[NoLinkedClients]
           ,[CreateDate])
      VALUES
           (@Name
           ,@Surname
		   ,@Email
           ,0
           ,getdate());

        SET @ID = SCOPE_IDENTITY(); -- Get the newly inserted contact's ID and set it to the output parameter
        PRINT 'Contact inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while inserting the contact.';
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.GetClient
    @ID INT
AS
BEGIN
    SELECT
        Name,
        ClientCode
    FROM
        Clients 
    WHERE
        ID = @ID;
END
GO

CREATE OR ALTER PROCEDURE dbo.GetContact
    @ID INT
AS
BEGIN
    SELECT
        Name,
        Surname,
		Email
    FROM
        Contacts 
    WHERE
        ID = @ID;
END
GO

CREATE OR ALTER PROCEDURE dbo.LinkClientToContact
    @ClientID INT,
    @ContactID INT
AS
BEGIN
    -- Check if the client and contact IDs exist in their respective tables
    IF NOT EXISTS (SELECT 1 FROM Clients WHERE id = @ClientID)
    BEGIN
        RAISERROR('Client ID does not exist.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Contacts WHERE id = @ContactID)
    BEGIN
        RAISERROR('Contact ID does not exist.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Check if the link already exists
        IF NOT EXISTS (SELECT 1 FROM ClientContacts WHERE ClientId = @ClientID AND ContactId = @ContactID)
        BEGIN
            -- Insert the link into the ClientContacts table
            INSERT INTO ClientContacts (ClientId, ContactId)
            VALUES (@ClientID, @ContactID);

            -- Update the NoLinkedClients count in the Contacts table
            UPDATE Contacts
            SET NoLinkedClients = NoLinkedClients + 1
            WHERE id = @ContactID;

            -- Update the NoLinkedContacts count in the Clients table
            UPDATE Clients
            SET NoLinkedContacts = NoLinkedContacts + 1
            WHERE id = @ClientID;

            PRINT 'Client linked to contact successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Link already exists.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while linking client to contact.';
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.UnlinkClientContact
    @ClientId INT,
    @ContactId INT
AS
BEGIN
    BEGIN TRY
        -- Check if the link exists in the ClientContacts table
        IF EXISTS (SELECT 1 FROM ClientContacts WHERE ClientId = @ClientId AND ContactId = @ContactId)
        BEGIN
            -- Remove the link from the ClientContacts table
            DELETE FROM ClientContacts WHERE ClientId = @ClientId AND ContactId = @ContactId;

            -- Update the NoLinkedClients count in the Contacts table
            UPDATE Contacts
            SET NoLinkedClients = NoLinkedClients - 1
            WHERE id = @ContactId;

            -- Update the NoLinkedContacts count in the Clients table
            UPDATE Clients
            SET NoLinkedContacts = NoLinkedContacts - 1
            WHERE id = @ClientId;

            PRINT 'Contact unlinked from client successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Link does not exist between the contact and client.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while unlinking contact from client.';
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.GetClientContacts
    @ClientID INT
AS
BEGIN
    SELECT 
		C.id AS ID,
        CONCAT(C.Surname, ' ', C.Name) AS Fullname,
        C.Email,
        CONCAT('<a href="/UnlinkContact?ClientId=', CC.ClientId, '&ContactId=', CC.ContactId, '">Unlink</a>') AS URL
    FROM 
        Contacts C
    INNER JOIN 
        ClientContacts CC ON C.id = CC.ContactId
    WHERE
        CC.ClientId = @ClientID
END;
GO

CREATE OR ALTER PROCEDURE dbo.GetContactClients
    @ContactID INT
AS
BEGIN
    SELECT 
		C.id AS ID,
        C.Name As Name,
		C.ClientCode As ClientCode,
        CONCAT('<a href="/UnlinkClient?ContactId=', CC.ContactId, '&ContactId=', CC.ClientId, '">Unlink</a>') AS URL
    FROM 
        Clients C
    INNER JOIN 
        ClientContacts CC ON C.id = CC.ClientId
    WHERE
        CC.ContactId = @ContactID
END;
GO

CREATE OR ALTER PROCEDURE dbo.DeleteClient
    @ClientID INT
AS
BEGIN
    -- Check if the client exists in the table
    IF NOT EXISTS (SELECT 1 FROM Clients WHERE id = @ClientID)
    BEGIN
        RAISERROR('Client ID does not exist.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Get the list of linked contacts for the deleted ClientId
		DECLARE @LinkedContacts TABLE (ContactId INT);
		INSERT INTO @LinkedContacts (ContactId)
		SELECT ContactId
		FROM ClientContacts
		WHERE ClientId = @ClientID;

		-- For each linked contact, decrement NoLinkedClients by 1
		UPDATE Contacts
		SET NoLinkedClients = NoLinkedClients - 1
		WHERE id IN (SELECT ContactId FROM @LinkedContacts);

		-- Delete corresponding rows from ClientContacts table
		DELETE FROM ClientContacts
		WHERE ClientId = @ClientID;

		-- Delete the client from the Clients table
		DELETE FROM Clients
		WHERE id = @ClientID;
		

        PRINT 'Client deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while deleting the client.';
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.DeleteContact
    @ContactID INT
AS
BEGIN
    -- Check if the contact exists in the table
    IF NOT EXISTS (SELECT 1 FROM Contacts WHERE id = @ContactID)
    BEGIN
        RAISERROR('Contact ID does not exist.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Get the list of linked contacts for the deleted ClientId
		DECLARE @LinkedClients TABLE (ClientId INT);
		INSERT INTO @LinkedClients (ClientId)
		SELECT ClientId
		FROM ClientContacts
		WHERE ContactId = @ContactID;

		-- For each linked contact, decrement NoLinkedClients by 1
		UPDATE Clients
		SET NoLinkedContacts = NoLinkedContacts - 1
		WHERE id IN (SELECT ClientId FROM @LinkedClients);

		-- Delete corresponding rows from ClientContacts table
		DELETE FROM ClientContacts
		WHERE ContactId = @ContactID;

		-- Delete the client from the Contacts table
		DELETE FROM Contacts
		WHERE id = @ContactID;

        PRINT 'Contact deleted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while deleting the contact.';
    END CATCH
END;
GO
