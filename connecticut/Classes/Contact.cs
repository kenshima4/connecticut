using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace connecticut.Classes
{
    public class Contact
    {
        public int id { get; set; }
        private string name;
        private string surname;
        private string email;

        private List<Client> linkedClients;
        public Contact(string name, string surname, string email) {
            this.linkedClients = new List<Client>();
            this.name = name;
            this.surname = surname;
            this.email = email;


        }

        public string getName() {
            return this.name;
        }

        public string getSurname()
        {
            return this.surname;
        }
        public string getEmail()
        {
            return this.email;
        }

        public List<Client> getLinkedClients(){
            return linkedClients;
        }
    }
}