using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Linq;

namespace connecticut.Classes
{
    
    public class Client
    {
        string name { get; set; }
        string clientCode { get; set; }
        List<Contact> contacts = new List<Contact>();

        public Client(string name) {
            this.name = name;
            this.clientCode = generateClientCode(this.name);
        }

        private string generateClientCode(string name) {
            int length = 3;

            return "AAA001";
        }

        


        public string getClientCode() {
            return this.clientCode;
        }
    }
}