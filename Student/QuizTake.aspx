<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizTake.aspx.cs" Inherits="Student_QuizTake" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Take Quiz</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:14px; margin-bottom: 20px;">
        <h1 style="font-size: 22px; margin:0;"><asp:Literal ID="litQuizTitle" runat="server" /></h1>
        <div class="cf-card cf-card-sm" style="padding:10px 16px;">
            <i class="fa-solid fa-clock" style="color:var(--amber);"></i>
            <span id="cfTimer" style="font-family:'JetBrains Mono',monospace; font-weight:700; margin-left:6px;">--:--</span>
        </div>
    </div>

    <asp:HiddenField ID="hfStartTicks" runat="server" />
    <asp:HiddenField ID="hfElapsedSeconds" runat="server" Value="0" />

    <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
        <ItemTemplate>
            <div class="cf-card mb-3">
                <p style="font-weight:600; margin-bottom:14px;">
                    <span class="pill pill-blue"><%# Container.ItemIndex + 1 %></span>
                    <%# Eval("QuestionText") %>
                </p>
                <asp:RadioButtonList ID="rblOptions" runat="server" />
                <asp:HiddenField ID="hfQuestionId" runat="server" Value='<%# Eval("QuestionID") %>' />
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="btn-cf btn-cf-primary" OnClick="btnSubmitQuiz_Click"
        OnClientClick="document.getElementById('<%= hfElapsedSeconds.ClientID %>').value = cfElapsedSeconds; return confirm('Submit your answers now?');" />

    <script>
        var cfElapsedSeconds = 0;
        (function () {
            var timerEl = document.getElementById('cfTimer');
            setInterval(function () {
                cfElapsedSeconds++;
                var m = Math.floor(cfElapsedSeconds / 60);
                var s = cfElapsedSeconds % 60;
                timerEl.textContent = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
            }, 1000);
        })();
    </script>

</asp:Content>
