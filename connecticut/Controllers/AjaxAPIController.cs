using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Diagnostics;

using connecticut.Classes;
namespace connecticut.Controllers
{
    public class AjaxAPIController : ApiController
    {
        private SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);


        
        [Route("AjaxMethod")]
        [HttpPost]
        public string UnlinkContact(int Client_ID, int Contact_ID)
        {
           
            try
            {
                using (SqlCommand myCom = new SqlCommand("dbo.UnlinkClientContact", myCon))
                {
                    // Link client id to contact id
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@ClientID", SqlDbType.Int).Value = Client_ID;
                    myCom.Parameters.Add("@ContactID", SqlDbType.Int).Value = Contact_ID;

                    myCom.ExecuteNonQuery();
                } 
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error in API UnlinkContact: " + ex.Message);
                return "Error in API UnlinkContact: " + ex.Message;
            }
            finally { myCon.Close(); }
            return "200 OK";
        }

        

    }

    

}
