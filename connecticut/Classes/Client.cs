﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;

namespace connecticut.Classes
{
    
    public class Client
    {
        
        string name { get; set; }
        string clientCode { get; set; }
        List<Contact> contacts = new List<Contact>();

        public Client(string name) {
            this.name = name;
        }

       
        public void generateClientCode() {
            //TODO fill
            this.clientCode = "AAA111";
            
        }

        // Method to get the unique numeric part of the client code
        private int GetUniqueNumericPart()
        {
            //TODO fill
            return 111;
        }



        public string getClientCode() {
            return this.clientCode;
        }
    }
}