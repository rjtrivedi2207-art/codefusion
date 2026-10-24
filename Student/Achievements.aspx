<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Achievements.aspx.cs" Inherits="Student_Achievements" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Achievements</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 24px;">
        <span class="pill pill-blue"><i class="fa-solid fa-crown"></i> Achievements</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Achievements</h1>
        <p class="text-muted-cf">Earn badges automatically as you complete lessons, quizzes and challenges. <asp:Literal ID="litCount" runat="server" /></p>
    </div>

    <div class="grid-auto" style="grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));">
        <asp:Repeater ID="rptBadges" runat="server">
            <ItemTemplate>
                <div class='cf-card cf-card-sm badge-tile <%# (bool)Eval("IsUnlocked") ? "" : "locked" %>'>
                    <i class='<%# Eval("IconClass") %>' style="font-size: 28px; color: var(--violet);"></i>
                    <h3 style="font-size:14px; margin-top:10px;"><%# Eval("Title") %></h3>
                    <p class="text-muted-cf" style="font-size:12px; margin:0;"><%# Eval("Description") %></p>
                    <span class='pill <%# (bool)Eval("IsUnlocked") ? "pill-green" : "pill-muted" %>' style="margin-top:10px;">
                        <%# (bool)Eval("IsUnlocked") ? "Unlocked" : "Locked" %>
                    </span>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

</asp:Content>
