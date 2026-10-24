<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizResult.aspx.cs" Inherits="Student_QuizResult" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Quiz Result</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="max-width: 560px; margin: 20px auto; text-align:center;">
        <div class="cf-card">
            <span class="pill pill-amber"><i class="fa-solid fa-swords"></i> <asp:Literal ID="litQuizTitle" runat="server" /></span>
            <h1 style="font-size: 44px; margin-top: 16px;"><asp:Literal ID="litPercentage" runat="server" />%</h1>
            <p class="text-muted-cf" style="font-size:15px;"><asp:Literal ID="litPerformanceMsg" runat="server" /></p>

            <div class="row g-3 mt-3">
                <div class="col-6">
                    <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litScore" runat="server" /></span><span class="label">Score</span></div>
                </div>
                <div class="col-6">
                    <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litCorrect" runat="server" /></span><span class="label">Correct</span></div>
                </div>
                <div class="col-6">
                    <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litIncorrect" runat="server" /></span><span class="label">Incorrect</span></div>
                </div>
                <div class="col-6">
                    <div class="cf-card cf-card-sm stat-tile"><span class="value"><asp:Literal ID="litTime" runat="server" /></span><span class="label">Time Taken</span></div>
                </div>
            </div>

            <div style="display:flex; gap:10px; justify-content:center; margin-top:26px;">
                <a href="~/Student/QuizArena.aspx" runat="server" class="btn-cf btn-cf-primary btn-cf-sm">Back to Quiz Arena</a>
                <a href="~/Student/QuizHistory.aspx" runat="server" class="btn-cf btn-cf-ghost btn-cf-sm">View History</a>
            </div>
        </div>
    </div>

</asp:Content>
