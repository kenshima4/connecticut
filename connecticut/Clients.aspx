<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Clients.aspx.cs" Inherits="connecticut.Clients" %>
 
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
            $('#modClientDetail').modal('show');
        }

        function openContactsDetail() {
            //alert("Opening modal!");
            $('#modContactsDetail').modal('show');
        }
    
        
        function unlinkClientContact(Client_ID, Contact_ID) {
            // Set the Client_ID value to the hidden field
            $('#<%= hdnClientID.ClientID %>').val(Client_ID);

            var requestData = {
                Client_ID: Client_ID,
                Contact_ID: Contact_ID
            };

            var json = JSON.stringify(requestData);

            $.ajax({
                type: "POST",
                url: "/api/AjaxAPI/UnlinkContact",
                data: json,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    alert(response.Message); // Access the "Message" property directly
                    console.log(response.Message);
                    // Trigger the click event on the hidden button
                    __doPostBack('<%= btnUpDetails.UniqueID %>', "");
                    
                },
                failure: function (response) {
                    alert(response.Message); 
                    console.log(response.Message);
                },
                error: function (response) {
                    alert(response.Message); 
                    console.log(response.Message);
                }
                
            });

            
            
        }

        
        
        
    </script>
 
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
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
                <div class="col-sm-2">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <%-- New Client Action --%>
                <div class="col-sm-6" style="text-align: right;">
                    <asp:Label ID="Label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>
                    <asp:LinkButton ID="lbNewClient" runat="server" Font-Size="12px" OnClick="lbNewClient_Click">New Client</asp:LinkButton>
                    <asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>
                </div>
            </div>
            
            <%-- Gridview List Clients --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:UpdatePanel ID="upClients" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:GridView ID="gvClients" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                DataKeyNames="ID"
                                CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
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
                                    <asp:BoundField DataField="Name" HeaderText="Client Name">
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
                                                OnClientClick="return confirm('Are you sure you want to delete this client?');" 
                                                CommandArgument='<%# Eval("ID") %>' CommandName="DelClient"/>
                                    
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
                            
                                    <%-- Select Client --%>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbSlcClient" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="SlcClient" Text="Select" CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    </asp:TemplateField>

                                    <%-- Link Client --%>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbLnkClient" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="LnkClient" Text="Link" CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    </asp:TemplateField>
                            
                                </Columns>
                            </asp:GridView>

                            
                        </ContentTemplate>
                        <Triggers>
                           <asp:AsyncPostBackTrigger ControlID="btnUpClients" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                    
                    <!-- Hidden button for Update Panels update -->
                    <asp:Button ID="btnUpClients" runat="server" Text="Update GridView" OnClick="btnUpClients_Click" style="display: none;" />

                </div>
            </div>
            
            <!-- Tabs -->
            <asp:UpdatePanel ID="upDetails" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-xs-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#tabGeneral">General</a></li>
                                <li><a data-toggle="tab" href="#tabContacts">Contact(s)</a></li>
                            </ul>
 
                            <div class="tab-content">
                                <!-- General Tab -->
                                <div id="tabGeneral" class="tab-pane fade in active">
                                    <h3>General</h3>
                                    <div class="form-group">
                                        <label for="lblClientName">Client Name:</label>
                                        <asp:TextBox ID="txtBoxClientName" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label for="lblClientCode">Client Code:</label>
                                        <asp:TextBox ID="txtBoxClientCode" runat="server" CssClass="form-control" ReadOnly="true" />
                                    </div>
                                </div>
 
                                <!-- Contact(s) Tab with gridview-->
                                <div id="tabContacts" class="row tab-pane fade in" style="margin-top: 20px;">
                                    <div class="col-sm-12">
                                        <asp:GridView ID="gvLinkedContacts" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                            DataKeyNames="ID"
                                            CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                                            OnRowCommand="gvLinkedContacts_RowCommand"
                                            EmptyDataText="No Contacts found!">
                                            <Columns>

                                            <asp:BoundField DataField="FullName" HeaderText="Full Name" ItemStyle-HorizontalAlign="Left" />
                                            <asp:BoundField DataField="Email" HeaderText="Email Address" ItemStyle-HorizontalAlign="Left" />
                                            <asp:TemplateField HeaderText="">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbUnlinkClientContact" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                        CommandName="unLnkContact" Text="Unlink" CausesValidation="false"></asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            </asp:TemplateField>
                                            <%--<asp:HyperLinkField CssClass="unlink-hyperlink"
                                                DataNavigateUrlFormatString="javascript:unlinkClientContact({0}, {1});"
                                                Text="Unlink" HeaderText="" ItemStyle-HorizontalAlign="Left" /> --%>
                                        

                                  
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>
                        
                            </div>
                        </div>
                    </div>
 
                    <!-- Modal to Add New or View / Update a Client Details-->
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
                                    <asp:Button ID="btnAddClient" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                                        Text="Add Client"
                                        Visible="true" CausesValidation="false"
                                        OnClick="btnAddClient_Click"
                                        UseSubmitBehavior="false" />
                                    <asp:Button ID="btnUpdClient" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                                        Text="Update Client"
                                        Visible="false" CausesValidation="false"
                                        OnClick="btnUpdClient_Click"
                                        UseSubmitBehavior="false" />
                                    <asp:Button ID="btnClose" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                        Text="Close" CausesValidation="false"
                                        UseSubmitBehavior="false" />
                                </div>
 
                            </div>
                        </div>
                    </div>

                    <!-- Modal to Show Avaiable Contacts -->
                    <div class="modal fade" id="modContactsDetail" tabindex="-1" role="dialog" aria-labelledby="contactsModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modContactsLabel">Available Contacts</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
                                    <!-- Display the list of contacts here -->
                                    <asp:GridView ID="gvContacts" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                    DataKeyNames="ID"
                                    CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                                    OnRowCommand="gvContacts_RowCommand"
                                    EmptyDataText="No Contact(s) found!">
                                        <Columns>
                                    
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

                                            <asp:BoundField DataField="NoLinkedClients" HeaderText="No. of Linked Clients">
                                                <HeaderStyle HorizontalAlign="Center" />
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>

                                            <%-- Link To Contact--%>
                                            <asp:TemplateField HeaderText="">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbLnkToContact" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                        CommandName="LnkContact" Text="Link" CausesValidation="false"></asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            </asp:TemplateField>

                                    
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>                

                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnUpDetails" EventName="Click" />
                </Triggers>
                                    
            </asp:UpdatePanel>
            <!-- Hidden button for Update Panels update -->
            <asp:Button ID="btnUpDetails" runat="server" Text="Update GridView" OnClick="btnUpDetails_Click" style="display: none;" />
            <asp:HiddenField ID="hdnClientID" runat="server" />
        </div>
    </form>

    
</body>
</html>