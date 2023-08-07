CREATE TABLE Contacts (
   id             INT CONSTRAINT PK_Contacts PRIMARY KEY IDENTITY,
   Name   VARCHAR(80) NOT NULL,
   Surname      VARCHAR(20) NOT NULL,
   Email          VARCHAR(80) NOT NULL,
   NoLinkedClients  INT NOT NULL,
   IsActive       BIT CONSTRAINT DF_IsActive_Contacts DEFAULT(1),
   CreateDate     DATETIME NOT NULL DEFAULT getdate()
);