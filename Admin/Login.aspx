<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Login · CodeFusion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="~/Content/css/theme.css" runat="server" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="cf-shell" style="max-width:420px; margin:100px auto;">
            <div class="cf-card">
                <span class="pill pill-violet"><i class="fa-solid fa-user-shield"></i> Admin</span>
                <h2 style="font-size:22px; margin-top:12px;">Admin sign in</h2>

                <asp:Literal ID="litServerError" runat="server" />

                <div class="cf-field">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="cf-input" placeholder="admin@codefusion.local" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." Display="Dynamic" CssClass="field-error" />
                </div>
                <div class="cf-field">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="cf-input" TextMode="Password" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." Display="Dynamic" CssClass="field-error" />
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="Log in" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnLogin_Click" />

                <p class="text-muted-cf" style="font-size:12.5px; text-align:center; margin-top:16px;">
                    <a href="~/Login.aspx" runat="server">Student login</a>
                </p>
            </div>
        </div>
    </form>
</body>
</html>
