CREATE TABLE Clients (
   id             INT CONSTRAINT PK_Clients PRIMARY KEY IDENTITY,
   Name	  VARCHAR(80) NOT NULL, -- Column name, data type and null value
   ClientCode	  VARCHAR(6) NOT NULL,
   NoLinkedContacts  INT NOT NULL,
   IsActive       BIT CONSTRAINT DF_IsActive_Clients DEFAULT(1),
   CreateDate     DATETIME NOT NULL DEFAULT getdate()
);