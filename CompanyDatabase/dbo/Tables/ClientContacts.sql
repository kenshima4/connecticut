-- Create the ClientContacts table (Intermediate table)
CREATE TABLE ClientContacts (
   ClientId       INT,
   ContactId      INT,
   CONSTRAINT PK_ClientContacts PRIMARY KEY (ClientId, ContactId),
   CONSTRAINT FK_ClientContacts_Clients FOREIGN KEY (ClientId) REFERENCES Clients (id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FK_ClientContacts_Contacts FOREIGN KEY (ContactId) REFERENCES Contacts (id) ON DELETE CASCADE ON UPDATE CASCADE
);