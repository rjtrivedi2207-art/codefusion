<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Modules.aspx.cs" Inherits="Admin_Modules" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Modules</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Modules</h1>
    <p class="text-muted-cf">The top-level learning modules shown on the student Learning page. Add a new one here — no code changes needed.</p>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;"><asp:Literal ID="litFormTitle" runat="server" Text="Add module" /></h3>
                <asp:Literal ID="litMessage" runat="server" />
                <asp:HiddenField ID="hfModuleId" runat="server" Value="0" />

                <div class="cf-field"><label>Module title</label><asp:TextBox ID="txtTitle" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Description</label><asp:TextBox ID="txtDescription" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="3" /></div>
                <div class="cf-field"><label>Module order</label><asp:TextBox ID="txtOrder" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><asp:CheckBox ID="chkActive" runat="server" Text="Active" Checked="true" /></div>

                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ModuleForm" />
                <asp:RequiredFieldValidator ID="rfvOrder" runat="server" ControlToValidate="txtOrder" ErrorMessage="Module order is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ModuleForm" />
                <asp:CompareValidator ID="cvOrder" runat="server" ControlToValidate="txtOrder" Operator="DataTypeCheck" Type="Integer" ErrorMessage="Order must be a whole number." Display="Dynamic" CssClass="field-error" ValidationGroup="ModuleForm" />

                <div style="display:flex; gap:10px; margin-top:10px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save module" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnSave_Click" ValidationGroup="ModuleForm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cf btn-cf-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvModules" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvModules_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ModuleOrder" HeaderText="#" />
                        <asp:BoundField DataField="ModuleTitle" HeaderText="Title" />
                        <asp:BoundField DataField="LessonCount" HeaderText="Lessons" />
                        <asp:TemplateField HeaderText="Active">
                            <ItemTemplate><span class='pill <%# (bool)Eval("IsActive") ? "pill-green" : "pill-muted" %>'><%# (bool)Eval("IsActive") ? "Yes" : "No" %></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='<%# "~/Admin/Lessons.aspx" %>' runat="server" class="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-book"></i> Lessons</a>
                                <asp:LinkButton runat="server" CommandName="EditModule" CommandArgument='<%# Eval("ModuleID") %>' CssClass="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteModule" CommandArgument='<%# Eval("ModuleID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this module? Only possible if it has no lessons.');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
