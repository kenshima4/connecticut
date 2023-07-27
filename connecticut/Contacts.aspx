<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="connecticut.Contacts" %>
 
<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contacts Page</title>
 
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
 
    <script type="text/javascript">
        function openEmpDetail() {
            //alert("Opening modal!");
            $('#modEmpDetail').modal('show');
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
                            <asp:HyperLink ID="hlClients" NavigateUrl="~/Clients.aspx" runat="server">Client</asp:HyperLink><br />
                        </li>
                        <li>
                            <asp:HyperLink ID="hlContacts" NavigateUrl="~/Contacts.aspx" runat="server">Contact</asp:HyperLink><br />
                        </li>
                    </ul>
                </div>
                <div class="col-sm-4">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
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
    </form>
</body>
</html>