<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Home</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section style="padding: 48px 0 32px 0;">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="pill pill-blue mb-3"><i class="fa-solid fa-terminal"></i> ASP.NET Web Forms · C# · SQL Server</span>
                <h1 style="font-size: 44px; line-height: 1.12; margin-top: 14px;">Learn ASP.NET.<br />Build. Practice. Debug. Master.</h1>
                <p class="text-muted-cf" style="font-size: 17px; max-width: 480px; margin-top: 16px;">
                    An interactive learning and practice platform for ASP.NET Web Forms students —
                    real controls, real SQL Server, real debugging, no fluff.
                </p>
                <div style="display:flex; gap:14px; margin-top: 28px; flex-wrap: wrap;">
                    <a href="~/Register.aspx" runat="server" class="btn-cf btn-cf-primary">
                        <i class="fa-solid fa-graduation-cap"></i> Start Learning
                    </a>
                    <a href="~/Login.aspx" runat="server" class="btn-cf btn-cf-ghost">
                        <i class="fa-solid fa-flask"></i> Explore Practice
                    </a>
                </div>
                <div style="display:flex; gap:28px; margin-top: 36px;">
                    <div class="stat-tile"><span class="value">12</span><span class="label">Roadmap Modules</span></div>
                    <div class="stat-tile"><span class="value">40+</span><span class="label">Guided Lessons</span></div>
                    <div class="stat-tile"><span class="value">3</span><span class="label">Debug Challenge Types</span></div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="hero-terminal">
                    <div class="hero-terminal-bar"><span></span><span></span><span></span></div>
                    <div class="hero-terminal-body" id="heroTerminalBody"></div>
                </div>
            </div>
        </div>
    </section>

    <section id="features" style="padding: 56px 0 8px 0;">
        <h2 style="font-size: 26px;">Everything a Web Forms student actually needs</h2>
        <p class="text-muted-cf" style="max-width: 560px;">Six focused areas that mirror how ASP.NET is actually taught and used — not a generic course catalog.</p>

        <div class="grid-auto" style="margin-top: 28px;">
            <div class="cf-card">
                <i class="fa-solid fa-book-open" style="color: var(--blue); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Interactive Lessons</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Explanation, syntax, live code and a practice task in every lesson.</p>
            </div>
            <div class="cf-card">
                <i class="fa-solid fa-flask-vial" style="color: var(--violet); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Practice Labs</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Controls, DropDownLists, validation and full CRUD against real SQL Server.</p>
            </div>
            <div class="cf-card">
                <i class="fa-solid fa-bug" style="color: var(--red); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Code Debugging</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Find the error, complete the code, fix the code — with progressive hints.</p>
            </div>
            <div class="cf-card">
                <i class="fa-solid fa-swords" style="color: var(--amber); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Quiz Arena</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Timed MCQ quizzes with instant scoring and a full attempt history.</p>
            </div>
            <div class="cf-card">
                <i class="fa-solid fa-chart-line" style="color: var(--green); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Progress Tracking</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Topic-wise performance and course completion at a glance.</p>
            </div>
            <div class="cf-card">
                <i class="fa-solid fa-crown" style="color: var(--blue); font-size: 22px;"></i>
                <h3 style="font-size: 17px; margin-top: 14px;">Achievements</h3>
                <p class="text-muted-cf" style="font-size: 14px; margin:0;">Earn XP and unlock badges as you move through the roadmap.</p>
            </div>
        </div>
    </section>

    <section id="roadmap-preview" style="padding: 56px 0 24px 0;">
        <h2 style="font-size: 26px;">The learning roadmap</h2>
        <p class="text-muted-cf" style="max-width: 560px;">Twelve modules, in order, from first principles to a working mini project.</p>

        <div class="roadmap" style="margin-top: 28px; max-width: 640px;">
            <asp:Repeater ID="rptRoadmapPreview" runat="server">
                <ItemTemplate>
                    <div class="roadmap-item">
                        <div class="roadmap-num"><%# Eval("ModuleOrder") %></div>
                        <div class="cf-card cf-card-sm">
                            <strong><%# Eval("ModuleTitle") %></strong>
                            <div class="text-muted-cf" style="font-size:12.5px; margin-top:3px;"><%# Eval("LessonCount") %> lessons</div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

</asp:Content>
