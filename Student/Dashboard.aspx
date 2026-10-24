<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Student_Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Dashboard</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:16px; margin-bottom: 26px;">
        <div>
            <h1 style="font-size: 28px;">Welcome back, <asp:Literal ID="litName" runat="server" /> <span style="font-size:22px;">👋</span></h1>
            <p class="text-muted-cf" style="margin:0;">
                Currently on <strong style="color:#fff;"><asp:Literal ID="litCurrentModule" runat="server" /></strong> ·
                <asp:Literal ID="litStreak" runat="server" /> day streak
            </p>
        </div>
        <a href="~/Student/Roadmap.aspx" runat="server" class="btn-cf btn-cf-primary">
            <i class="fa-solid fa-play"></i> Continue Learning
        </a>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile">
                <span class="value"><asp:Literal ID="litCompletionPct" runat="server" />%</span>
                <span class="label">Course Complete</span>
                <div class="cf-progress thin green mt-2"><span id="barCompletion" runat="server" /></div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile">
                <span class="value"><asp:Literal ID="litXP" runat="server" /></span>
                <span class="label">Total XP · Level <asp:Literal ID="litLevel" runat="server" /></span>
                <div class="cf-progress thin mt-2"><span id="barXP" runat="server" /></div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile">
                <span class="value"><asp:Literal ID="litQuizAvg" runat="server" />%</span>
                <span class="label">Quiz Average</span>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="cf-card cf-card-sm stat-tile">
                <span class="value"><asp:Literal ID="litBadges" runat="server" /></span>
                <span class="label">Badges Earned</span>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="cf-card mb-4">
                <h3 style="font-size:16px;">Quick actions</h3>
                <div class="grid-auto" style="grid-template-columns: repeat(auto-fit,minmax(140px,1fr)); margin-top:12px;">
                    <a href="~/Student/Roadmap.aspx" runat="server" class="cf-card cf-card-sm" style="text-align:center; color:var(--text);">
                        <i class="fa-solid fa-book-open" style="color:var(--blue); font-size:20px;"></i>
                        <div style="margin-top:8px; font-size:13.5px; font-weight:600;">Learn</div>
                    </a>
                    <a href="~/Practice/Index.aspx" runat="server" class="cf-card cf-card-sm" style="text-align:center; color:var(--text);">
                        <i class="fa-solid fa-flask-vial" style="color:var(--violet); font-size:20px;"></i>
                        <div style="margin-top:8px; font-size:13.5px; font-weight:600;">Practice</div>
                    </a>
                    <a href="~/Practice/DebugLab.aspx" runat="server" class="cf-card cf-card-sm" style="text-align:center; color:var(--text);">
                        <i class="fa-solid fa-bug" style="color:var(--red); font-size:20px;"></i>
                        <div style="margin-top:8px; font-size:13.5px; font-weight:600;">Debug Lab</div>
                    </a>
                    <a href="~/Student/QuizArena.aspx" runat="server" class="cf-card cf-card-sm" style="text-align:center; color:var(--text);">
                        <i class="fa-solid fa-swords" style="color:var(--amber); font-size:20px;"></i>
                        <div style="margin-top:8px; font-size:13.5px; font-weight:600;">Quiz Arena</div>
                    </a>
                    <a href="~/Student/Progress.aspx" runat="server" class="cf-card cf-card-sm" style="text-align:center; color:var(--text);">
                        <i class="fa-solid fa-chart-line" style="color:var(--green); font-size:20px;"></i>
                        <div style="margin-top:8px; font-size:13.5px; font-weight:600;">Progress</div>
                    </a>
                </div>
            </div>

            <div class="cf-card">
                <h3 style="font-size:16px;">Recent activity</h3>
                <asp:Repeater ID="rptActivity" runat="server">
                    <ItemTemplate>
                        <div style="display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px solid var(--border); font-size:13.5px;">
                            <span><i class='<%# Eval("IconClass") %>' style="color: var(--blue); width:18px;"></i> <%# Eval("Description") %></span>
                            <span class="text-muted-cf"><%# Eval("WhenText") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Literal ID="litNoActivity" runat="server" />
            </div>
        </div>

        <div class="col-lg-4">
            <div class="cf-card">
                <h3 style="font-size:16px;">Roadmap snapshot</h3>
                <div class="roadmap" style="margin-top:16px;">
                    <asp:Repeater ID="rptRoadmapSnapshot" runat="server">
                        <ItemTemplate>
                            <div class='roadmap-item <%# (int)Eval("CompletionPercent") == 100 ? "done" : "" %>'>
                                <div class="roadmap-num">
                                    <%# (int)Eval("CompletionPercent") == 100 ? "<i class=\"fa-solid fa-check\"></i>" : Eval("ModuleOrder") %>
                                </div>
                                <a href='<%# "~/Student/ModuleLessons.aspx?id=" + Eval("ModuleID") %>' runat="server" style="display:block; padding: 8px 0; font-size:13.5px; color:var(--text);">
                                    <%# Eval("ModuleTitle") %> <span class="text-muted-cf">(<%# Eval("CompletionPercent") %>%)</span>
                                </a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <a href="~/Student/Roadmap.aspx" runat="server" class="btn-cf btn-cf-ghost btn-cf-block btn-cf-sm" style="margin-top:8px;">View all modules</a>
            </div>
        </div>
    </div>

</asp:Content>
