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

        function openClientsDetail() {
            //alert("Opening modal!");
            $('#modClientsDetail').modal('show');
        }

        function unlinkClientContact(Client_ID, Contact_ID) {
            // Set the built-in Client_ID value to the hidden field
            $('#<%= hdnContactID.ClientID %>').val(Client_ID);

            var requestData = {
                Client_ID: Client_ID,
                Contact_ID: Contact_ID
            };

            var json = JSON.stringify(requestData);

            $.ajax({
                type: "POST",
                url: "/api/AjaxAPI/UnlinkClientContact",
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
 
            
            <%-- Gridview Contacts --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:UpdatePanel ID="upContacts" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:GridView ID="gvContacts" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                DataKeyNames="ID"
                                CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
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

                                    <asp:BoundField DataField="NoLinkedClients" HeaderText="No. of Linked Clients">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                           
 
                                    <%-- Delete Contact --%>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDelContact" Text="Del" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this contact?');" 
                                                CommandName="DelContact" CausesValidation="false"/>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                                    </asp:TemplateField>

                                    <%-- Select Contact --%>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbSlcContact" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="SlcContact" Text="Select" CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    </asp:TemplateField>

                                    <%-- Link --%>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbLnkClient" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="LnkContact" Text="Link" CausesValidation="false"></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                        
                    </asp:UpdatePanel>
                </div>
            </div>

            <!-- Tabs for Contact info -->
            <asp:UpdatePanel ID="upDetails" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-xs-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#tabGeneral">General</a></li>
                                <li><a data-toggle="tab" href="#tabClients">Client(s)</a></li>
                            </ul>
 
                            <div class="tab-content">
                                <!-- General Tab -->
                                <div id="tabGeneral" class="tab-pane fade in active">
                                    <h3>General</h3>
                                    <div class="form-group">
                                        <label for="lblContactName">Name:</label>
                                        <asp:TextBox ID="txtBoxContactName" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label for="lblContactSurname">Surname:</label>
                                        <asp:TextBox ID="txtBoxContactSurname" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label for="lblContactEmail">Email:</label>
                                        <asp:TextBox ID="txtBoxContactEmail" runat="server" CssClass="form-control" />
                                    </div>
                                </div>
 
                                <!-- Client(s) Tab with gridview-->
                                <div id="tabClients" class="row tab-pane fade in" style="margin-top: 20px;">
                                    <div class="col-sm-12">
                                        <asp:GridView ID="gvLinkedClients" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                            DataKeyNames="ID"
                                            CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                                            OnRowCommand="gvLinkedClients_RowCommand"
                                            EmptyDataText="No Client(s) found!">
                                            <Columns>
                                            <asp:BoundField DataField="Name" HeaderText="Client Name" ItemStyle-HorizontalAlign="Left" />
                                            <asp:BoundField DataField="ClientCode" HeaderText="Client Code" ItemStyle-HorizontalAlign="Left" />
                                            <asp:TemplateField HeaderText="">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbUnlinkClientContact" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                        CommandName="unLnkClient" Text="Unlink" CausesValidation="false"></asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                            </asp:TemplateField>
                                        </Columns>
                                        </asp:GridView>


                                    </div>
                                </div>
                        
                            </div>
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
                                                    <div class="col-sm-10"> <%-- Use form-inline class for inline layout --%>
                                                        <asp:TextBox ID="txtContactName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                            ToolTip="Name"
                                                            AutoCompleteType="Disabled" placeholder="Name" />
                                                        <asp:Label runat="server" ID="lblClientID" Visible="false" Font-Size="12px" />
                                                    </div>
                                                    <div class="col-sm-1"></div>
                                                </div>
                                                <div class="row" style="margin-top: 20px;">
                                                    <div class="col-sm-1"></div>
                                                    <%-- surname --%>
                                                    <div class="col-sm-10"> 
                                                        <asp:TextBox ID="txtContactSurname" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                            ToolTip="Surname"
                                                            AutoCompleteType="Disabled" placeholder="Surname" />
                                                        <asp:Label runat="server" ID="Label1" Visible="false" Font-Size="12px" />
                                                    </div>
                                                    <div class="col-sm-1"></div>
                                                </div>
                                                <div class="row" style="margin-top: 20px;">
                                                    <div class="col-sm-1"></div>
                                                    <%-- email --%>
                                                    <div class="col-sm-10"> 
                                                        <asp:TextBox ID="txtContactEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                            ToolTip="Email Address" AutoCompleteType="Disabled" placeholder="Email Address" />
                                                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtContactEmail"
                                                            ErrorMessage="Invalid email format" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                                                            ValidationGroup="vgContacts" OnServerValidate="revEmail_ServerValidate"/>
                                                    </div>
                                            
                                                    <div class="col-sm-1"></div>
                                            
                                                </div>
            
                                    
                                        </div>

                                    </div>
                                </div>
 
                                <%-- Add, Update and Cancel Buttons --%>
                                <div class="modal-footer">
                                    <asp:Button ID="btnAddContact" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                                        Text="Add Contact"
                                        Visible="true" CausesValidation="true"
                                        OnClick="btnAddContact_Click"
                                        ValidationGroup="vgContacts"
                                        UseSubmitBehavior="false" />
                                    <asp:Button ID="btnUpdContact" runat="server" class="btn btn-info button-xs" data-dismiss="modal" 
                                        Text="Update Contact"
                                        Visible="false" CausesValidation="false"
                                        OnClick="btnUpdContact_Click"
                                        UseSubmitBehavior="false" />
                                    <asp:Button ID="btnClose" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                                        Text="Close" CausesValidation="false"
                                        UseSubmitBehavior="false" />
                                </div>
 
                            </div>
                        </div>
                    </div>

                    <!-- Modal to Show Avaiable Clients -->
                    <div class="modal fade" id="modClientsDetail" tabindex="-1" role="dialog" aria-labelledby="clientsModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modClientsLabel">Available Clients</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
                                    <!-- Display the list of clients here -->
                                    <asp:GridView ID="gvClients" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                    DataKeyNames="ID"
                                    CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                                    OnRowCommand="gvClients_RowCommand"
                                    EmptyDataText="No Client(s) found!">
                                        <Columns>
                                    
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

                                            <%-- Link To Client --%>
                                            <asp:TemplateField HeaderText="">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lbLnkToClient" runat="server" CommandArgument='<%# Eval("ID") %>'
                                                        CommandName="LnkClient" Text="Link" CausesValidation="false"></asp:LinkButton>
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
            <asp:HiddenField ID="hdnContactID" runat="server" />
        </div>
    </form>
</body>
</html>