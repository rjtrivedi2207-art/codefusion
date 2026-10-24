<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="Student_Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">My Profile</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="max-width: 480px; margin: 20px auto;">
        <div class="cf-card" style="text-align:center;">
            <div class="cf-avatar" style="width:64px; height:64px; font-size:24px; margin: 0 auto 16px auto;"><asp:Literal ID="litInitial" runat="server" /></div>
            <h2 style="font-size:20px;"><asp:Literal ID="litName" runat="server" /></h2>
            <p class="text-muted-cf" style="font-size:13.5px;"><asp:Literal ID="litEmail" runat="server" /></p>

            <div class="row g-3 mt-2">
                <div class="col-4"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litXP" runat="server" /></span><span class="label">XP</span></div></div>
                <div class="col-4"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litLevel" runat="server" /></span><span class="label">Level</span></div></div>
                <div class="col-4"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litStreak" runat="server" /></span><span class="label">Streak</span></div></div>
            </div>

            <p class="text-muted-cf" style="font-size:12.5px; margin-top:18px;">Member since <asp:Literal ID="litJoined" runat="server" /></p>
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="btn-cf btn-cf-ghost btn-cf-sm" OnClick="btnLogout_Click">Logout</asp:LinkButton>
        </div>
    </div>

</asp:Content>
