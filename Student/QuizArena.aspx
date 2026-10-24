<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizArena.aspx.cs" Inherits="Student_QuizArena" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Quiz Arena</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:flex-end; flex-wrap:wrap; gap:14px; margin-bottom: 24px;">
        <div>
            <span class="pill pill-amber"><i class="fa-solid fa-swords"></i> Quiz Arena</span>
            <h1 style="font-size: 26px; margin-top: 10px;">Quiz Arena</h1>
            <p class="text-muted-cf" style="margin:0;">Timed MCQ quizzes with instant scoring.</p>
        </div>
        <a href="~/Student/QuizHistory.aspx" runat="server" class="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a>
    </div>

    <div class="grid-auto">
        <asp:Repeater ID="rptQuizzes" runat="server">
            <ItemTemplate>
                <div class="cf-card">
                    <span class="pill pill-blue"><%# Eval("QuizType") %></span>
                    <h3 style="font-size:16px; margin-top:12px;"><%# Eval("Title") %></h3>
                    <p class="text-muted-cf" style="font-size:13px;">
                        <i class="fa-solid fa-clock"></i> <%# Eval("TimeLimitMin") %> min ·
                        <i class="fa-solid fa-list-check"></i> <%# Eval("QuestionCount") %> questions
                    </p>
                    <a href='<%# "~/Student/QuizTake.aspx?id=" + Eval("QuizID") %>' runat="server" class="btn-cf btn-cf-primary btn-cf-sm btn-cf-block">
                        <i class="fa-solid fa-play"></i> Start Quiz
                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal ID="litEmpty" runat="server" Visible="false" Text="<p class='text-muted-cf'>No quizzes available yet — check back soon.</p>" />
    </div>

</asp:Content>
