<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Register</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="max-width: 440px; margin: 24px auto;">
        <div class="cf-card">
            <h2 style="font-size: 22px;">Create your account</h2>
            <p class="text-muted-cf" style="font-size: 14px; margin-bottom: 22px;">Start the ASP.NET roadmap in under a minute.</p>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="field-error" DisplayMode="BulletList" HeaderText="Please fix the following:" />
            <asp:Literal ID="litServerError" runat="server" />

            <div class="cf-field">
                <label for="txtFullName">Full name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="cf-input" placeholder="e.g. Aarav Shah" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required." Display="Dynamic" CssClass="field-error" />
            </div>

            <div class="cf-field">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="cf-input" placeholder="you@example.com" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." Display="Dynamic" CssClass="field-error" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email address."
                    Display="Dynamic" CssClass="field-error" />
            </div>

            <div class="cf-field">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="cf-input" TextMode="Password" placeholder="At least 6 characters" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." Display="Dynamic" CssClass="field-error" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                    ValidationExpression=".{6,}" ErrorMessage="Password must be at least 6 characters."
                    Display="Dynamic" CssClass="field-error" />
            </div>

            <div class="cf-field">
                <label for="txtConfirm">Confirm password</label>
                <asp:TextBox ID="txtConfirm" runat="server" CssClass="cf-input" TextMode="Password" placeholder="Re-enter password" />
                <asp:CompareValidator ID="cvConfirm" runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPassword"
                    ErrorMessage="Passwords do not match." Display="Dynamic" CssClass="field-error" />
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnRegister_Click" />

            <p class="text-muted-cf" style="font-size: 13.5px; text-align:center; margin-top:18px;">
                Already have an account? <a href="~/Login.aspx" runat="server">Log in</a>
            </p>
        </div>
    </div>

</asp:Content>
