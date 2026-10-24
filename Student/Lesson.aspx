<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Lesson.aspx.cs" Inherits="Student_Lesson" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Lesson</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href='<%= ResolveUrl("~/Student/ModuleLessons.aspx") %>?id=<%= ModuleIdForBackLink %>' class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Back to module</a>

    <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:14px; margin: 14px 0 10px 0;">
        <div>
            <span class="pill pill-blue"><asp:Literal ID="litModuleTitle" runat="server" /></span>
            <h1 style="font-size: 26px; margin-top: 10px;"><asp:Literal ID="litTitle" runat="server" /></h1>
            <p class="text-muted-cf" style="margin:0; max-width:620px;"><asp:Literal ID="litShortDescription" runat="server" /></p>
        </div>
        <asp:Button ID="btnMarkComplete" runat="server" Text="Mark as completed" CssClass="btn-cf btn-cf-primary" OnClick="btnMarkComplete_Click" />
        <asp:Literal ID="litAlreadyDone" runat="server" Visible="false" />
    </div>

    <div class="row g-4" style="margin-top:14px;">
        <div class="col-lg-8">

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Learning objectives</h3>
                <ul style="margin-top:10px; padding-left:18px; font-size:14px; margin-bottom:0;">
                    <asp:Repeater ID="rptObjectives" runat="server">
                        <ItemTemplate><li style="margin-bottom:6px;"><%# Container.DataItem %></li></ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Explanation</h3>
                <p style="margin-top:10px; white-space:pre-line;"><asp:Literal ID="litExplanation" runat="server" /></p>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Syntax</h3>
                <div class="code-block" style="margin-top:10px;"><asp:Literal ID="litSyntax" runat="server" /></div>
            </div>

            <div class="cf-card mb-4">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em; margin:0;">Code example</h3>
                    <span class="pill pill-violet"><asp:Literal ID="litCodeLanguage" runat="server" /></span>
                </div>
                <div class="code-block" style="margin-top:10px;"><asp:Literal ID="litCodeExample" runat="server" /></div>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Line-by-line explanation</h3>
                <ul style="margin-top:10px; padding-left:18px; font-size:14px; margin-bottom:0;">
                    <asp:Repeater ID="rptCodeExplanation" runat="server">
                        <ItemTemplate><li style="margin-bottom:8px;"><%# Container.DataItem %></li></ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Expected output</h3>
                <p style="margin-top:10px; margin-bottom:0;"><asp:Literal ID="litExpectedOutput" runat="server" /></p>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Real-world use</h3>
                <p style="margin-top:10px; margin-bottom:0;"><asp:Literal ID="litRealWorldUse" runat="server" /></p>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Practice task</h3>
                <p style="margin-top:10px; margin-bottom:0;"><asp:Literal ID="litPracticeTask" runat="server" /></p>
            </div>

            <!-- Mini quiz -->
            <div class="cf-card" ID="miniQuizCard" runat="server">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Mini quiz</h3>
                <asp:Literal ID="litQuizResult" runat="server" />
                <asp:Repeater ID="rptMiniQuiz" runat="server">
                    <ItemTemplate>
                        <div style="padding:12px 0; border-bottom:1px solid var(--border);">
                            <p style="font-weight:600; margin-bottom:10px; font-size:14px;"><%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %></p>
                            <asp:RadioButtonList ID="rblMiniQuiz" runat="server" />
                            <asp:HiddenField ID="hfMiniQuestionId" runat="server" Value='<%# Eval("LessonQuizQuestionID") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Button ID="btnCheckQuiz" runat="server" Text="Check answers" CssClass="btn-cf btn-cf-ghost btn-cf-sm mt-2" OnClick="btnCheckQuiz_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="col-lg-4">
            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Key points</h3>
                <ul style="margin-top:12px; padding-left:18px; font-size:14px; margin-bottom:0;">
                    <asp:Repeater ID="rptKeyPoints" runat="server">
                        <ItemTemplate><li style="margin-bottom:8px;"><%# Container.DataItem %></li></ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--red); text-transform:uppercase; letter-spacing:.04em;"><i class="fa-solid fa-triangle-exclamation"></i> Common mistakes</h3>
                <ul style="margin-top:12px; padding-left:18px; font-size:14px; margin-bottom:0;">
                    <asp:Repeater ID="rptMistakes" runat="server">
                        <ItemTemplate><li style="margin-bottom:8px;"><%# Container.DataItem %></li></ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div class="cf-card mb-4">
                <h3 style="font-size:15px; color:var(--amber); text-transform:uppercase; letter-spacing:.04em;"><i class="fa-solid fa-wrench"></i> Troubleshooting</h3>
                <ul style="margin-top:12px; padding-left:18px; font-size:14px; margin-bottom:0;">
                    <asp:Repeater ID="rptTroubleshooting" runat="server">
                        <ItemTemplate><li style="margin-bottom:8px;"><%# Container.DataItem %></li></ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>

            <div class="cf-card">
                <h3 style="font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;">Up next</h3>
                <asp:Literal ID="litNextLink" runat="server" />
            </div>
        </div>
    </div>

</asp:Content>
