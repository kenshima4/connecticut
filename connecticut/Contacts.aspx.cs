using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace connecticut
{
    public partial class Contacts : System.Web.UI.Page
    {
        int Contact_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView();
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

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Contacts doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdCompany")
            {
                Contact_ID = Convert.ToInt32(e.CommandArgument);

                GetContact(Contact_ID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openClientDetail();", true);
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

        private void GetContact(int Comp_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.GetContacts", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = Comp_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            //txtClientName.Text = myDr.GetValue(1).ToString();
                            //txtClientCode.Text = myDr.GetValue(2).ToString();

                            //lblClientID.Text = Client_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies GetCompany: " + ex.Message; }
            finally { myCon.Close(); }
        }
    }
}