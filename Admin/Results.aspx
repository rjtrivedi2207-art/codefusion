<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Results.aspx.cs" Inherits="Admin_Results" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Results</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Quiz Results</h1>
    <p class="text-muted-cf">Every quiz attempt across all students.</p>

    <div class="cf-card" style="overflow-x:auto;">
        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle" GridLines="None">
            <Columns>
                <asp:BoundField DataField="FullName" HeaderText="Student" />
                <asp:BoundField DataField="Title" HeaderText="Quiz" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:BoundField DataField="TotalMarks" HeaderText="Out of" />
                <asp:TemplateField HeaderText="Percentage">
                    <ItemTemplate><%# Math.Round(Convert.ToDouble(Eval("Score")) / Math.Max(1, Convert.ToDouble(Eval("TotalMarks"))) * 100, 0) %>%</ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="AttemptedOn" HeaderText="Date" DataFormatString="{0:dd MMM yyyy, HH:mm}" />
            </Columns>
            <EmptyDataTemplate><p class="text-muted-cf" style="padding:16px 0; margin:0;">No quiz attempts yet.</p></EmptyDataTemplate>
        </asp:GridView>
    </div>

</asp:Content>
