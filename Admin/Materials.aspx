<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Materials.aspx.cs" Inherits="Admin_Materials" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Materials</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Study Materials</h1>
    <p class="text-muted-cf">Upload a PDF or add a text-based material for students to browse.</p>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;">Add material</h3>
                <asp:Literal ID="litMessage" runat="server" />
                <div class="cf-field"><label>Title</label><asp:TextBox ID="txtTitle" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Description</label><asp:TextBox ID="txtDescription" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Topic</label><asp:TextBox ID="txtTopic" runat="server" CssClass="cf-input" placeholder="e.g. Validation Controls" /></div>
                <div class="cf-field">
                    <label>Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="cf-select" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                        <asp:ListItem Text="PDF upload" Value="PDF" />
                        <asp:ListItem Text="Text content" Value="Text" />
                    </asp:DropDownList>
                </div>
                <asp:PlaceHolder ID="phPdf" runat="server">
                    <div class="cf-field"><label>PDF file</label><asp:FileUpload ID="fuPdf" runat="server" CssClass="cf-input" /></div>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phText" runat="server" Visible="false">
                    <div class="cf-field"><label>Text content</label><asp:TextBox ID="txtContent" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="5" /></div>
                </asp:PlaceHolder>

                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="MatForm" />
                <asp:RequiredFieldValidator ID="rfvTopic" runat="server" ControlToValidate="txtTopic" ErrorMessage="Topic is required." Display="Dynamic" CssClass="field-error" ValidationGroup="MatForm" />

                <asp:Button ID="btnAdd" runat="server" Text="Add material" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnAdd_Click" ValidationGroup="MatForm" />
            </div>
        </div>

        <div class="col-lg-7">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvMaterials" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvMaterials_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="Title" />
                        <asp:BoundField DataField="Topic" HeaderText="Topic" />
                        <asp:BoundField DataField="MaterialType" HeaderText="Type" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="DeleteMaterial" CommandArgument='<%# Eval("MaterialID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this material?');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate><p class="text-muted-cf" style="padding:16px 0; margin:0;">No materials yet.</p></EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
