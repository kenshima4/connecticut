using System;
using System.Collections.Generic;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;

namespace connecticut.Classes
{
    
    public class Client
    {
        
        public string name { get; set; }
        public int id { get; set; }
        public string clientCode { get; set; }
        List<Contact> contacts = new List<Contact>();
        public int noLinkedContacts { get; set; }

        public ClientCodeGenerator cGen;

        public Client(ClientCodeGenerator cGen, string name) {
            
            this.name = name;
            this.noLinkedContacts = 0;
            this.cGen = cGen;
            string code = cGen.GenerateClientCode(name);
            this.clientCode = cGen.AddUniqueNumericPart(code);

        }

       
        



        public string getClientCode() {
            return this.clientCode;
        }
    }
}