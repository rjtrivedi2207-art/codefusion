<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NotFound.aspx.cs" Inherits="ErrorPages_NotFound" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Page not found · CodeFusion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="~/Content/css/theme.css" runat="server" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="cf-shell" style="max-width:520px; margin:100px auto; text-align:center;">
            <div class="cf-card">
                <i class="fa-solid fa-magnifying-glass" style="font-size:34px; color: var(--blue);"></i>
                <h2 style="font-size:22px; margin-top:16px;">Page not found</h2>
                <p class="text-muted-cf">The page you're looking for doesn't exist or may have moved.</p>
                <a href="~/Default.aspx" runat="server" class="btn-cf btn-cf-primary btn-cf-sm">Back to Home</a>
            </div>
        </div>
    </form>
</body>
</html>
