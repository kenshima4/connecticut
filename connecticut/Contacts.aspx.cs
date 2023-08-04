using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

using connecticut.Classes;
namespace connecticut
{
    public partial class Contacts : System.Web.UI.Page
    {
        int Contact_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);
        private List<Contact> contacts = new List<Contact>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView();
                DoClientsGridView();
               
            }
        }
        private void DoGridView()
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

                    upContacts.Update();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Contacts doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void DoClientsGridView()
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

                    upDetails.Update();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Clients doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void DoLinkedClientsGridView(int Contact_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetContactClients", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    myCom.Parameters.Add("@ContactID", SqlDbType.Int).Value = Contact_ID;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvLinkedClients.DataSource = myDr;
                    gvLinkedClients.DataBind();

                    upDetails.Update();

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

        protected void btnUpDetails_Click(object sender, EventArgs e)
        {
            // Get the Client_ID value from the hidden field
            int Contact_ID = Convert.ToInt32(hdnContactID.Value);

            DoLinkedClientsGridView(Contact_ID);
            DoClientsGridView();
            DoGridView();
        }

        protected void lbNewContact_Click(object sender, EventArgs e)
        {
            try
            {
                txtContactName.Text = "";
                txtContactSurname.Text = "";
                txtContactEmail.Text = "";
                
                lblContactNew.Visible = true;
                lblContactUpd.Visible = false;
                btnAddContact.Visible = true;
                btnUpdContact.Visible = false;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openContactDetail();", true);
            }
            catch (Exception) { throw; }
        }

        protected void revEmail_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Validate the email format using the regular expression
            args.IsValid = Utils.isValidEmail(txtContactEmail.Text); 
        }

        protected void btnAddContact_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.InsContact", myCon))
                {
                    // Create a new client object with the ID and add it to your clients list
                    Contact newContact = new Contact(txtContactName.Text, txtContactSurname.Text, txtContactEmail.Text);
                   
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@Name", SqlDbType.NVarChar).Value = txtContactName.Text;
                    myCom.Parameters.Add("@Surname", SqlDbType.NVarChar).Value = txtContactSurname.Text;
                    myCom.Parameters.Add("@Email", SqlDbType.NVarChar).Value = txtContactEmail.Text;

                    // Add an output parameter for the client ID
                    SqlParameter outputParameter = new SqlParameter("@ID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    myCom.Parameters.Add(outputParameter);

                    myCom.ExecuteNonQuery();

                    // Get the newly inserted client's ID from the output parameter
                    int newContactId = (int)outputParameter.Value;
                    newContact.id = newContactId;
                    contacts.Add(newContact);
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void btnUpdContact_Click(object sender, EventArgs e)
        {
            UpdContact();
            DoGridView();
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            Contact_ID = Convert.ToInt32(e.CommandArgument);
            // Store the selected client ID in ViewState
            ViewState["Contact_ID"] = Contact_ID;

            if (e.CommandName == "DelContact")
            {
                gvContacts_RowCommandDelete(Contact_ID);
            }
            else if (e.CommandName == "SlcContact") 
            {
                gvContacts_RowCommandSelect(Contact_ID);
            }

            else if (e.CommandName == "LnkContact")
            {
                gvContacts_RowCommandLink();
            }
        }

        protected void gvLinkedClients_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int Client_ID = Convert.ToInt32(e.CommandArgument);
            // Retrieve the selected client ID from ViewState
            if (ViewState["Contact_ID"] != null && ViewState["Contact_ID"] is int)
            {
                int Contact_ID = (int)ViewState["Contact_ID"];


                if (e.CommandName == "unLnkClient")
                {
                    unlinkClientContact(Client_ID, Contact_ID);
                }

            }
        }

        protected void gvContacts_RowCommandDelete(int Contact_ID)
        {
            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.DeleteContact", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ContactID", SqlDbType.Int).Value = Contact_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvContacts_RowCommandDelete: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void gvContacts_RowCommandSelect(int Contact_ID)
        {
            GetContact(Contact_ID);
            DoLinkedClientsGridView(Contact_ID);
        }

        protected void gvContacts_RowCommandLink()

        {
            // Open modal with list of contacts
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openClientsDetail();", true);
        }

        protected void gvClients_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int Client_ID = Convert.ToInt32(e.CommandArgument);
            // Retrieve the selected client ID from ViewState
            if (ViewState["Contact_ID"] != null && ViewState["Contact_ID"] is int)
            {
                int Contact_ID = (int)ViewState["Contact_ID"];


                if (e.CommandName == "LnkClient")
                {
                    linkToClient(Client_ID, Contact_ID);
                }
            }
        }

        protected void gvContacts_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Contact_ID = Convert.ToInt32(gvContacts.DataKeys[e.RowIndex].Value.ToString());

            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.usp_DelContact", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = Contact_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvContacts_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        private void GetContact(int Contact_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetContact", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = Contact_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtBoxContactName.Text = myDr.GetValue(0).ToString();
                            txtBoxContactSurname.Text = myDr.GetValue(1).ToString();
                            txtBoxContactEmail.Text = myDr.GetValue(2).ToString();

                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Contacts GetContact: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void UpdContact()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_UpdContact", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = int.Parse(lblClientID.Text);
                    cmd.Parameters.Add("@Name", SqlDbType.VarChar).Value = txtContactName.Text;
                    cmd.Parameters.Add("@Surname", SqlDbType.VarChar).Value = txtContactSurname.Text;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = txtContactEmail.Text;
                    //cmd.Parameters.Add("@ClientCode", SqlDbType.VarChar).Value = txtClientCode.Text;


                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies UpdClient: " + ex.Message; }
            finally { myCon.Close(); }
        }


        protected void linkToClient(int Client_ID, int Contact_ID)
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
            finally
            {
                myCon.Close();
                DoLinkedClientsGridView(Contact_ID);
                DoGridView();
            }
        }

        protected void unlinkClientContact(int Client_ID, int Contact_ID)
        {
            string script = "unlinkClientContact(" + Client_ID + ", " + Contact_ID + ");";
            // Pass associated update panel to javascript function
            ScriptManager.RegisterStartupScript(upDetails, this.GetType(), "unlinkClientContact", script, true);

        }
    }
}