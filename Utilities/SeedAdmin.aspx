<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SeedAdmin.aspx.cs" Inherits="Utilities_SeedAdmin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Seed Admin · CodeFusion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="~/Content/css/theme.css" runat="server" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="cf-shell" style="max-width:460px; margin:80px auto;">
            <div class="cf-card">
                <span class="pill pill-amber"><i class="fa-solid fa-triangle-exclamation"></i> One-time setup utility</span>
                <h2 style="font-size:20px; margin-top:12px;">Create the first Admin account</h2>
                <p class="text-muted-cf" style="font-size:13.5px;">
                    Run this once after deploying the database, then <strong>delete this file</strong>
                    (or the whole <code>Utilities</code> folder) — leaving a page that can create
                    admin accounts is a security risk in a real deployment.
                </p>

                <asp:Literal ID="litMessage" runat="server" />

                <div class="cf-field"><label>Full name</label><asp:TextBox ID="txtName" runat="server" CssClass="cf-input" Text="CodeFusion Admin" /></div>
                <div class="cf-field"><label>Email</label><asp:TextBox ID="txtEmail" runat="server" CssClass="cf-input" Text="admin@codefusion.local" /></div>
                <div class="cf-field"><label>Password</label><asp:TextBox ID="txtPassword" runat="server" CssClass="cf-input" TextMode="Password" /></div>

                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required." Display="Dynamic" CssClass="field-error" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." Display="Dynamic" CssClass="field-error" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic" CssClass="field-error" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ValidationExpression=".{6,}"
                    ErrorMessage="Password must be at least 6 characters." Display="Dynamic" CssClass="field-error" />

                <asp:Button ID="btnCreate" runat="server" Text="Create admin account" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnCreate_Click" />
            </div>
        </div>
    </form>
</body>
</html>
