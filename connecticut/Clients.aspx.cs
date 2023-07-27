﻿using System;
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
    public partial class Clients : System.Web.UI.Page
    {
        int Client_ID;
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
        protected void lbNewClient_Click(object sender, EventArgs e)
        {
            try
            {
                txtClientName.Text = "";
                txtClientCode.Text = "";

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
                using (SqlCommand myCom = new SqlCommand("dbo.usp_InsCompany", myCon))
                {
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@CompanyName", SqlDbType.VarChar).Value = txtClientName.Text;
                    myCom.Parameters.Add("@CompAddress", SqlDbType.VarChar).Value = txtClientCode.Text;

                    myCom.ExecuteNonQuery();
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
            if (e.CommandName == "UpdCompany")
            {
                Client_ID = Convert.ToInt32(e.CommandArgument);


                txtClientName.Text = "";
                txtClientCode.Text = "";
               
                lblClientNew.Visible = false;
                lblClientUpd.Visible = true;
                btnAddClient.Visible = false;
                btnUpdClient.Visible = true;

                GetClient(Client_ID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openClientDetail();", true);
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
        private void GetClient(int Comp_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.usp_GetClient", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = Comp_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtClientName.Text = myDr.GetValue(1).ToString();
                            txtClientCode.Text = myDr.GetValue(2).ToString();
                           
                            lblClientID.Text = Client_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies GetCompany: " + ex.Message; }
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
                    cmd.Parameters.Add("@ClientName", SqlDbType.VarChar).Value = txtClientName.Text;
                    cmd.Parameters.Add("@ClientCode", SqlDbType.VarChar).Value = txtClientCode.Text;


                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies UpdClient: " + ex.Message; }
            finally { myCon.Close(); }
        }
    }
}