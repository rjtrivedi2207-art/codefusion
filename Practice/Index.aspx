<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Practice_Index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Practice Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 24px;">
        <span class="pill pill-violet"><i class="fa-solid fa-flask-vial"></i> Practice Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">ASP.NET Practice Lab</h1>
        <p class="text-muted-cf">Hands-on exercises for every core Web Forms concept — pick a lab to get started.</p>
    </div>

    <div class="grid-auto">
        <a href="~/Practice/ArithmeticLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-calculator" style="color: var(--blue); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">Arithmetic Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">Addition, subtraction, BMI, simple interest and more — postback calculators with validation.</p>
        </a>
        <a href="~/Practice/ControlsLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-sliders" style="color: var(--violet); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">ASP.NET Controls Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">Live demos of Label, TextBox, CheckBox, DropDownList, Calendar, GridView and more.</p>
        </a>
        <a href="~/Practice/DropDownLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-layer-group" style="color: var(--green); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">DropDownList Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">Cascading Country → State → City dropdowns using AutoPostBack and data binding.</p>
        </a>
        <a href="~/Practice/ValidationLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-shield-halved" style="color: var(--amber); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">Validation Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">RequiredField, Compare, Range, RegularExpression, Custom validators and ValidationSummary.</p>
        </a>
        <a href="~/Practice/CrudLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-database" style="color: var(--blue); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">CRUD Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">Full Create, Read, Update, Delete against a real SQL Server Employee table.</p>
        </a>
        <a href="~/Practice/DebugLab.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-bug" style="color: var(--red); font-size: 22px;"></i>
            <h3 style="font-size: 16px; margin-top: 14px;">Debug Lab</h3>
            <p class="text-muted-cf" style="font-size: 13.5px; margin:0;">Find the error, complete the code, or fix the code — with progressive hints.</p>
        </a>
    </div>

</asp:Content>
