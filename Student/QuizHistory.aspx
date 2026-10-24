<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizHistory.aspx.cs" Inherits="Student_QuizHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Quiz History</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Student/QuizArena.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Quiz Arena</a>
    <h1 style="font-size: 26px; margin: 14px 0 20px 0;">Quiz History</h1>

    <div class="cf-card" style="overflow-x:auto;">
        <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle" GridLines="None">
            <Columns>
                <asp:BoundField DataField="Title" HeaderText="Quiz" />
                <asp:BoundField DataField="AttemptedOn" HeaderText="Date" DataFormatString="{0:dd MMM yyyy, HH:mm}" />
                <asp:BoundField DataField="Score" HeaderText="Score" />
                <asp:TemplateField HeaderText="Percentage">
                    <ItemTemplate>
                        <%# Math.Round(Convert.ToDouble(Eval("Score")) / Math.Max(1, Convert.ToDouble(Eval("TotalMarks"))) * 100, 0) %>%
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Result">
                    <ItemTemplate>
                        <span class='pill <%# (Convert.ToDouble(Eval("Score")) / Math.Max(1, Convert.ToDouble(Eval("TotalMarks")))) >= 0.5 ? "pill-green" : "pill-amber" %>'>
                            <%# (Convert.ToDouble(Eval("Score")) / Math.Max(1, Convert.ToDouble(Eval("TotalMarks")))) >= 0.5 ? "Pass" : "Review" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <p class="text-muted-cf" style="padding:16px 0; margin:0;">No quiz attempts yet — head to the Quiz Arena to take your first one.</p>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

</asp:Content>
