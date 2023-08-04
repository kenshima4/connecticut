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


        
        [Route("api/AjaxAPI/UnlinkClientContact")]
        [HttpPost]
        public IHttpActionResult UnlinkClientContact([FromBody] UnlinkContactRequest requestData)
        {
            try
            {
                int Client_ID = requestData.Client_ID;
                int Contact_ID = requestData.Contact_ID;

                
                
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.UnlinkClientContact", myCon))
                {
                    // Link client id to contact id
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@ClientID", SqlDbType.Int).Value = Client_ID;
                    myCom.Parameters.Add("@ContactID", SqlDbType.Int).Value = Contact_ID;

                    myCom.ExecuteNonQuery();
                }

                return Ok(new { Message = "Unlink successful." });
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error in API UnlinkContact: " + ex.Message);
                // If there's an error, return an error response with a message
                var responseMessage = new HttpResponseMessage(HttpStatusCode.InternalServerError)
                {
                    Content = new StringContent("Error in API UnlinkContact: " + ex.Message),
                    ReasonPhrase = "Internal Server Error"
                };
                return ResponseMessage(responseMessage);
            }
            finally { 
                myCon.Close(); 
            }
        }



        // Create a separate class to represent the request data
        public class UnlinkContactRequest
        {
            public int Client_ID { get; set; }
            public int Contact_ID { get; set; }
        }



    }

    

}
