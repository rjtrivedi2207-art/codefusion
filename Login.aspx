<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Log In</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="max-width: 420px; margin: 40px auto;">
        <div class="cf-card">
            <h2 style="font-size: 22px;">Welcome back</h2>
            <p class="text-muted-cf" style="font-size: 14px; margin-bottom: 22px;">Log in to continue your roadmap.</p>

            <asp:Literal ID="litInfo" runat="server" />
            <asp:Literal ID="litServerError" runat="server" />

            <div class="cf-field">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="cf-input" placeholder="you@example.com" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." Display="Dynamic" CssClass="field-error" />
            </div>

            <div class="cf-field">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="cf-input" TextMode="Password" placeholder="Your password" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." Display="Dynamic" CssClass="field-error" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Log in" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnLogin_Click" />

            <p class="text-muted-cf" style="font-size: 13.5px; text-align:center; margin-top:18px;">
                New to CodeFusion? <a href="~/Register.aspx" runat="server">Create an account</a>
            </p>
            <p style="text-align:center; margin-top:6px;">
                <a href="~/Admin/Login.aspx" runat="server" class="text-muted-cf" style="font-size:12.5px;">Admin login</a>
            </p>
        </div>
    </div>

</asp:Content>
