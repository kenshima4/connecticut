using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using connecticut.Classes;
namespace connecticut
{
    public partial class Clients : System.Web.UI.Page
    {
        int Client_ID;
        private List <Client> clients = new List<Client>();
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView();
                DoContactsGridView();
            }
        }

        
        private void DoGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetClients", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvClients.DataSource = myDr;
                    gvClients.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Clients doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void DoContactsGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetContacts", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvContacts.DataSource = myDr;
                    gvContacts.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Clients doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void DoLinkedContactsGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetClientContacts", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    myCom.Parameters.Add("@ClientID", SqlDbType.Int).Value = (int)ViewState["Client_ID"];

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvLinkedContacts.DataSource = myDr;
                    gvLinkedContacts.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error in DoLinkedContactsGridView: " + ex.Message;
            }
            finally
            {
                myCon.Close();
            }
        }

        
        protected void lbNewClient_Click(object sender, EventArgs e)
        {
            try
            {
                txtClientName.Text = "";

                lblClientNew.Visible = true;
                lblClientUpd.Visible = false;
                btnAddClient.Visible = true;
                btnUpdClient.Visible = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openClientDetail();", true);
            }
            catch (Exception) { throw; }
        }

        protected void btnAddClient_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.InsClient", myCon))
                {
                    // Create a new client object with the ID and add it to your clients list
                    Client newClient = new Client(txtClientName.Text);
                    string clientCode = newClient.getClientCode();

                    

                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@Name", SqlDbType.NVarChar).Value = txtClientName.Text;
                    myCom.Parameters.Add("@ClientCode", SqlDbType.NVarChar).Value = clientCode;

                    // Add an output parameter for the client ID
                    SqlParameter outputParameter = new SqlParameter("@ID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    myCom.Parameters.Add(outputParameter);

                    myCom.ExecuteNonQuery();

                    // Get the newly inserted client's ID from the output parameter
                    int newClientId = (int)outputParameter.Value;
                    newClient.id = newClientId;
                    clients.Add(newClient);
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in btnAddClient_Click: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }
        protected void btnUpdClient_Click(object sender, EventArgs e)
        {
            UpdClient();
            DoGridView();
        }
        protected void gvClients_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            Client_ID = Convert.ToInt32(e.CommandArgument);
            // Store the selected client ID in ViewState
            ViewState["Client_ID"] = Client_ID;
            

            if (e.CommandName == "UpdClient")
            {

                gvClients_RowCommandUpdate(Client_ID);
            }
            else if (e.CommandName == "SlcClient")
            {
                gvClients_RowCommandSelect(Client_ID);
            }
            else if (e.CommandName == "LnkClient") {
                gvClients_RowCommandLink();
            }
        }

        protected void gvClients_RowCommandUpdate(int Client_ID) 
        {
            
            txtClientName.Text = "";

            lblClientNew.Visible = false;
            lblClientUpd.Visible = true;
            btnAddClient.Visible = false;
            btnUpdClient.Visible = true;

            GetClient(Client_ID);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openClientDetail();", true);
        }

        protected void gvClients_RowCommandSelect(int Client_ID)
        {
            GetClient(Client_ID);
            DoLinkedContactsGridView();
        }

        protected void gvClients_RowCommandLink()

        {
            // Open modal with list of contacts
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openContactsDetail();", true);
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int Contact_ID = Convert.ToInt32(e.CommandArgument);
            // Retrieve the selected client ID from ViewState
            if (ViewState["Client_ID"] != null && ViewState["Client_ID"] is int)
            {
                int Client_ID = (int)ViewState["Client_ID"];
               

                if (e.CommandName == "LnkContact")
                {
                    linkToContact(Client_ID, Contact_ID);
                }
            }
        }

        protected void linkToContact(int Client_ID, int Contact_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.LinkClientToContact", myCon))
                {
                    // Link client id to contact id
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@ClientID", SqlDbType.Int).Value = Client_ID;
                    myCom.Parameters.Add("@ContactID", SqlDbType.Int).Value = Contact_ID;

                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in linkToContact: " + ex.Message; }
            finally { 
                myCon.Close();
                DoLinkedContactsGridView();
                DoGridView();
            }
        }
        protected void gvClients_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Client_ID = Convert.ToInt32(gvClients.DataKeys[e.RowIndex].Value.ToString());
            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.DelClient", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = Client_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvClients_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }
        private void GetClient(int Client_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetClient", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = Client_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtBoxClientName.Text = myDr.GetValue(0).ToString();
                            txtBoxClientCode.Text = myDr.GetValue(1).ToString();
                           
                            lblClientID.Text = Client_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Client GetClient: " + ex.Message; }
            finally { myCon.Close(); }
        }
        private void UpdClient()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_UpdClient", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = int.Parse(lblClientID.Text);
                    cmd.Parameters.Add("@Name", SqlDbType.VarChar).Value = txtClientName.Text;
                    //cmd.Parameters.Add("@ClientCode", SqlDbType.VarChar).Value = txtClientCode.Text;


                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies UpdClient: " + ex.Message; }
            finally { myCon.Close(); }
        }

        
    }
}