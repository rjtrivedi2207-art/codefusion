<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Students.aspx.cs" Inherits="Admin_Students" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Students</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Students</h1>
    <p class="text-muted-cf">View, search, and activate or deactivate student accounts.</p>

    <div class="cf-card mb-3">
        <div style="display:flex; gap:10px;">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="cf-input" placeholder="Search by name or email..." />
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-cf btn-cf-primary btn-cf-sm" OnClick="btnSearch_Click" CausesValidation="false" />
        </div>
    </div>

    <div class="cf-card" style="overflow-x:auto;">
        <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
            OnRowCommand="gvStudents_RowCommand" GridLines="None">
            <Columns>
                <asp:BoundField DataField="StudentID" HeaderText="ID" />
                <asp:BoundField DataField="FullName" HeaderText="Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="XP" HeaderText="XP" />
                <asp:BoundField DataField="Level" HeaderText="Level" />
                <asp:BoundField DataField="CreatedOn" HeaderText="Joined" DataFormatString="{0:dd MMM yyyy}" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='pill <%# (bool)Eval("IsActive") ? "pill-green" : "pill-red" %>'>
                            <%# (bool)Eval("IsActive") ? "Active" : "Deactivated" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName='<%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>'
                            CommandArgument='<%# Eval("StudentID") %>'
                            CssClass='<%# (bool)Eval("IsActive") ? "btn-cf btn-cf-danger btn-cf-sm" : "btn-cf btn-cf-primary btn-cf-sm" %>'>
                            <%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <p class="text-muted-cf" style="padding:16px 0; margin:0;">No students found.</p>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

</asp:Content>
