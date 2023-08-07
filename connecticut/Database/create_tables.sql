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
DROP TABLE IF EXISTS Contacts;
DROP TABLE IF EXISTS ClientContacts;
 
CREATE TABLE Clients (
   id             INT CONSTRAINT PK_Clients PRIMARY KEY IDENTITY,
   Name	  VARCHAR(80) NOT NULL, -- Column name, data type and null value
   ClientCode	  VARCHAR(6) NOT NULL,
   NoLinkedContacts  INT NOT NULL,
   IsActive       BIT CONSTRAINT DF_IsActive_Clients DEFAULT(1),
   CreateDate     DATETIME NOT NULL DEFAULT getdate()
);
 
CREATE TABLE Contacts (
   id             INT CONSTRAINT PK_Contacts PRIMARY KEY IDENTITY,
   Name   VARCHAR(80) NOT NULL,
   Surname      VARCHAR(20) NOT NULL,
   Email          VARCHAR(80) NOT NULL,
   NoLinkedClients  INT NOT NULL,
   IsActive       BIT CONSTRAINT DF_IsActive_Contacts DEFAULT(1),
   CreateDate     DATETIME NOT NULL DEFAULT getdate()
);

-- Create the ClientContacts table (Intermediate table)
CREATE TABLE ClientContacts (
   ClientId       INT,
   ContactId      INT,
   CONSTRAINT PK_ClientContacts PRIMARY KEY (ClientId, ContactId),
   CONSTRAINT FK_ClientContacts_Clients FOREIGN KEY (ClientId) REFERENCES Clients (id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FK_ClientContacts_Contacts FOREIGN KEY (ContactId) REFERENCES Contacts (id) ON DELETE CASCADE ON UPDATE CASCADE
);