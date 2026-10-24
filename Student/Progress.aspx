<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Progress.aspx.cs" Inherits="Student_Progress" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">My Progress</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 24px;">
        <span class="pill pill-green"><i class="fa-solid fa-chart-line"></i> Progress</span>
        <h1 style="font-size: 26px; margin-top: 10px;">My Progress</h1>
        <p class="text-muted-cf">A snapshot of how far you've come across every part of CodeFusion.</p>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">Course completion</h3>
                <div class="cf-progress green mt-2" style="height:10px;"><span id="barCourse" runat="server" /></div>
                <p class="text-muted-cf mt-2" style="font-size:13px;"><asp:Literal ID="litLessonsSummary" runat="server" /></p>
            </div>
        </div>
        <div class="col-md-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">Quiz average</h3>
                <div class="cf-progress mt-2" style="height:10px;"><span id="barQuiz" runat="server" /></div>
                <p class="text-muted-cf mt-2" style="font-size:13px;"><asp:Literal ID="litQuizSummary" runat="server" /></p>
            </div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litLessonsDone" runat="server" /></span><span class="label">Lessons Completed</span></div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litChallengesDone" runat="server" /></span><span class="label">Challenges Solved</span></div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litQuizzesTaken" runat="server" /></span><span class="label">Quizzes Taken</span></div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litBadgesCount" runat="server" /></span><span class="label">Badges Earned</span></div>
        </div>
    </div>

    <div class="cf-card">
        <h3 style="font-size:16px;">Progress by module</h3>
        <div style="margin-top:14px;">
            <asp:Repeater ID="rptModules" runat="server">
                <ItemTemplate>
                    <div style="padding:12px 0; border-bottom:1px solid var(--border);">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                            <span style="font-size:14px; font-weight:600;">Module <%# Eval("ModuleOrder") %> — <%# Eval("ModuleTitle") %></span>
                            <span class="text-muted-cf" style="font-size:12.5px;"><%# Eval("CompletedLessonCount") %> / <%# Eval("LessonCount") %> lessons (<%# Eval("CompletionPercent") %>%)</span>
                        </div>
                        <div class="cf-progress thin green"><span style='width:<%# Eval("CompletionPercent") %>%' /></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

</asp:Content>
