<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Dashboard</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Welcome, <asp:Literal ID="litAdminName" runat="server" /></h1>
    <p class="text-muted-cf">Platform overview at a glance.</p>

    <div class="row g-3 mt-2">
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litStudents" runat="server" /></span><span class="label">Students</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litModules" runat="server" /></span><span class="label">Modules</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litLessons" runat="server" /></span><span class="label">Lessons</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litMaterials" runat="server" /></span><span class="label">Materials</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litQuizzes" runat="server" /></span><span class="label">Quizzes</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litQuestions" runat="server" /></span><span class="label">Questions</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litChallenges" runat="server" /></span><span class="label">Challenges</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litAttempts" runat="server" /></span><span class="label">Quiz Attempts</span></div></div>
        <div class="col-6 col-md-3"><div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litEmployees" runat="server" /></span><span class="label">Employee Rows (CRUD Lab)</span></div></div>
    </div>

    <div class="grid-auto mt-4">
        <a href="~/Admin/Students.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-user-graduate" style="color:var(--blue); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Students</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">View, search, activate or deactivate students.</p>
        </a>
        <a href="~/Admin/Modules.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-layer-group" style="color:var(--blue); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Modules</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">Add, edit and reorder the top-level learning modules.</p>
        </a>
        <a href="~/Admin/Lessons.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-book" style="color:var(--violet); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Lessons</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">Add, edit and delete lessons within a module.</p>
        </a>
        <a href="~/Admin/Quizzes.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-swords" style="color:var(--amber); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Quizzes &amp; Questions</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">Create quizzes and manage their questions.</p>
        </a>
        <a href="~/Admin/Challenges.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-bug" style="color:var(--red); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Debug Challenges</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">Add and remove Debug Lab challenges.</p>
        </a>
        <a href="~/Admin/Results.aspx" runat="server" class="cf-card" style="color:var(--text);">
            <i class="fa-solid fa-chart-column" style="color:var(--green); font-size:20px;"></i>
            <h3 style="font-size:15px; margin-top:10px;">Results</h3>
            <p class="text-muted-cf" style="font-size:13px; margin:0;">View every student's quiz results.</p>
        </a>
    </div>

</asp:Content>
