﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Clients.aspx.cs" Inherits="connecticut.Clients" %>
 
<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Clients Page</title>
 
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
 
    <script type="text/javascript">
        function openClientDetail() {
            //alert("Opening modal!");
            $('#modCoDetail').modal('show');
        }
    </script>
 
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
 
            <%-- Webpage Heading --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Clients Page</h1>
                </div>
            </div>
 
            <%-- Menu / Message / New link --%>
            <div class="navbar-collapse collapse">
                <div class="col-sm-4">
                    <ul class="nav navbar-nav" style="font-weight: bold;">
                        <li>
                            <asp:HyperLink ID="hlHome" NavigateUrl="~/Default.aspx" runat="server">Home</asp:HyperLink><br />
                        </li>
                        <li>
                            <asp:HyperLink ID="hlClients" NavigateUrl="~/Clients.aspx" runat="server">Clients</asp:HyperLink><br />
                        </li>
                        <li>
                            <asp:HyperLink ID="hlContacts" NavigateUrl="~/Contacts.aspx" runat="server">Contacts</asp:HyperLink><br />
                        </li>
                    </ul>
                </div>
                <div class="col-sm-4">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <div class="col-sm-4" style="text-align: right;">
                    <asp:Label ID="Label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>
                    <asp:LinkButton ID="lbNewClient" runat="server" Font-Size="12px" OnClick="lbNewClient_Click">New</asp:LinkButton>
                    <asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>
                </div>
            </div>
 
            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvClients" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="ID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvClients_RowDeleting"
                        OnRowCommand="gvClients_RowCommand"
                        EmptyDataText="No Client(s) found!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="ClientName" HeaderText="Client Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ClientCode" HeaderText="Client Code">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NoLinkedContacts" HeaderText="No. of Linked Contacts">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
 
                            <%-- Delete Client --%>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelClient" Text="Del" runat="server"
                                        OnClientClick="return confirm('Are you sure you want to delete this client?');" CommandName="Delete" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                            </asp:TemplateField>
 
                            <%-- Update Client --%>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbUpdClient" runat="server" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="UpdClient" Text="Upd" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
 
        <!-- Modal to Add New or View / Update a Company Details-->
        <div class="modal fade" id="modClientDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">
 
                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblClientNew" runat="server" Text="Add New Client" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblClientUpd" runat="server" Text="View / Update a Client" Font-Size="24px" Font-Bold="true" />
                    </div>
 
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">
 
                                <%-- Client Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtClientName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Client Name"
                                                AutoCompleteType="Disabled" placeholder="Client Name" />
                                            <asp:Label runat="server" ID="lblClientID" Visible="false" Font-Size="12px" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtClientCode" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Company Address"
                                                AutoCompleteType="Disabled" placeholder="Client Code" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
 
                        </div>
 
                        <%-- Message label on modal page --%>
                        <div class="row" style="margin-top: 20px; margin-bottom: 10px;">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-10">
                                <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>
 
                    <%-- Add, Update and Cancel Buttons --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddClient" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Add Client"
                            Visible="true" CausesValidation="false"
                            OnClick="btnAddClient_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnUpdClient" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Update Client"
                            Visible="false" CausesValidation="false"
                            OnClick="btnUpdClient_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnClose" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                            Text="Close" CausesValidation="false"
                            UseSubmitBehavior="false" />
                    </div>
 
                </div>
            </div>
        </div>
    </form>
</body>
</html>