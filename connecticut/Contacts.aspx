<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="connecticut.Contacts" %>
 
<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contacts Page</title>
 
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
 
    <script type="text/javascript">
        function openContactDetail() {
            //alert("Opening modal!");
            $('#modContactDetail').modal('show');
        }
    </script>
 
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="container">
 
            <%-- Webpage Heading --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1>Contacts Page</h1>
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
                    <asp:Label ID="label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>
                    <asp:LinkButton ID="lbNewContact" runat="server" Font-Size="12px" OnClick="lbNewContact_Click">New Contact</asp:LinkButton>
                    <asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>
                </div>
                
            </div>
 
            
            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvContacts" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="ID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvContacts_RowDeleting"
                        OnRowCommand="gvContacts_RowCommand"
                        EmptyDataText="No Contact(s) found!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Name" HeaderText="Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Surname" HeaderText="Surname">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Email" HeaderText="Email">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LinkedClients" HeaderText="No. of Linked Clients">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                           
 
                            <%-- Delete Contact --%>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelContact" Text="Del" runat="server"
                                        OnClientClick="return confirm('Are you sure you want to delete this contact?');" CommandName="Delete" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                            </asp:TemplateField>
 
                            <%-- Update Contact --%>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbUpdContact" runat="server" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="UpdClient" Text="Upd" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- Modal to Add New or View / Update a Contact Details-->
            <div class="modal fade" id="modContactDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" style="width: 600px;">
                    <div class="modal-content" style="font-size: 11px;">
 
                        <div class="modal-header" style="text-align: center;">
                            <asp:Label ID="lblContactNew" runat="server" Text="Add New Contact" Font-Size="24px" Font-Bold="true" />
                            <asp:Label ID="lblContactUpd" runat="server" Text="View / Update a Contact" Font-Size="24px" Font-Bold="true" />
                        </div>
 
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-sm-12">
 
                                    <%-- Contact Details Textboxes --%>
                                    
                                        <div class="row" style="margin-top: 20px;">
                    
                                            <div class="col-sm-1"></div>
                                            <%-- first name --%>
                                            <div class="col-sm-10 form-inline"> <%-- Use form-inline class for inline layout --%>
                                                <asp:TextBox ID="txtContactName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Name"
                                                    AutoCompleteType="Disabled" placeholder="Name" />
                                                <asp:Label runat="server" ID="lblClientID" Visible="false" Font-Size="12px" />
                                            </div>

                                            <%-- surname --%>
                                            <div class="col-sm-10 form-inline"> 
                                                <asp:TextBox ID="txtContactSurname" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Surname"
                                                    AutoCompleteType="Disabled" placeholder="Surname" />
                                                <asp:Label runat="server" ID="Label1" Visible="false" Font-Size="12px" />
                                            </div>

                                            <%-- email --%>
                                            
                                            <div class="col-sm-10 form-inline"> 
                                                <asp:TextBox ID="txtContactEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Email Address"
                                                    AutoCompleteType="Disabled" placeholder="email address" />
                                                <asp:Label runat="server" ID="Label2" Visible="false" Font-Size="12px" />
                                            </div>
                                            <div class="col-sm-1"></div>
                                        </div>
                
            
                                    
                                </div>

                            </div>
                        </div>
 
                        <%-- Add, Update and Cancel Buttons --%>
                        <div class="modal-footer">
                            <asp:Button ID="btnAddContact" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                Text="Add Contact"
                                Visible="true" CausesValidation="false"
                                OnClick="btnAddContact_Click"
                                UseSubmitBehavior="false" />
                            <asp:Button ID="btnUpdContact" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                Text="Update Contact"
                                Visible="false" CausesValidation="false"
                                OnClick="btnUpdContact_Click"
                                UseSubmitBehavior="false" />
                            <asp:Button ID="btnClose" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                                Text="Close" CausesValidation="false"
                                UseSubmitBehavior="false" />
                        </div>
 
                    </div>
                </div>
            </div>
            
        </div>
    </form>
</body>
</html>