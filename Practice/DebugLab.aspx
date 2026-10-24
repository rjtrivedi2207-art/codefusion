<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="DebugLab.aspx.cs" Inherits="Practice_DebugLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Debug Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 24px;">
        <span class="pill pill-red"><i class="fa-solid fa-bug"></i> CodeFusion Debug Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Debug Lab</h1>
        <p class="text-muted-cf">Find the Error, Complete the Code, and Fix the Code challenges. Use hints if you're stuck — each hint used lowers the XP a little.</p>
    </div>

    <asp:PlaceHolder ID="phList" runat="server">
        <div class="grid-auto">
            <asp:Repeater ID="rptChallenges" runat="server" OnItemCommand="rptChallenges_ItemCommand">
                <ItemTemplate>
                    <div class="cf-card">
                        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:6px;">
                            <span class='pill <%# GetDifficultyPill(Eval("Difficulty").ToString()) %>'><%# Eval("Difficulty") %></span>
                            <span class="pill pill-violet"><%# Eval("Category") %></span>
                        </div>
                        <p style="margin: 14px 0; font-size: 14px;"><%# Eval("Question") %></p>
                        <asp:LinkButton runat="server" CommandName="Open" CommandArgument='<%# Eval("ChallengeID") %>' CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block">
                            <i class="fa-solid fa-play"></i> Attempt (+<%# Eval("XPReward") %> XP)
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="phAttempt" runat="server" Visible="false">
        <a href="~/Practice/DebugLab.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> All challenges</a>

        <div class="row g-4" style="margin-top: 10px;">
            <div class="col-lg-7">
                <div class="cf-card">
                    <div style="display:flex; gap:8px; flex-wrap:wrap;">
                        <span class="pill pill-muted"><asp:Literal ID="litType" runat="server" /></span>
                        <span class="pill pill-violet"><asp:Literal ID="litCategory" runat="server" /></span>
                    </div>
                    <h3 style="font-size:17px; margin-top:12px;"><asp:Literal ID="litQuestion" runat="server" /></h3>
                    <div class="code-block" style="margin-top:12px;"><asp:Literal ID="litCode" runat="server" /></div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="cf-card">
                    <h3 style="font-size:15px;">Hints</h3>
                    <asp:Button ID="btnHint1" runat="server" Text="Reveal Hint 1" CssClass="btn-cf btn-cf-ghost btn-cf-sm btn-cf-block" OnClick="btnHint1_Click" CausesValidation="false" />
                    <asp:Literal ID="litHint1" runat="server" Visible="false" />
                    <asp:Button ID="btnHint2" runat="server" Text="Reveal Hint 2" CssClass="btn-cf btn-cf-ghost btn-cf-sm btn-cf-block mt-2" OnClick="btnHint2_Click" CausesValidation="false" />
                    <asp:Literal ID="litHint2" runat="server" Visible="false" />

                    <asp:Button ID="btnReveal" runat="server" Text="Reveal solution" CssClass="btn-cf btn-cf-ghost btn-cf-sm btn-cf-block mt-3" OnClick="btnReveal_Click" CausesValidation="false" />
                    <asp:PlaceHolder ID="phSolution" runat="server" Visible="false">
                        <div class="code-block mt-2"><asp:Literal ID="litSolution" runat="server" /></div>
                        <asp:PlaceHolder ID="phPrevention" runat="server" Visible="false">
                            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);">
                                <strong style="color:var(--green);"><i class="fa-solid fa-shield-halved"></i> How to prevent this:</strong>
                                <p style="margin:6px 0 0 0; font-size:13.5px;"><asp:Literal ID="litPreventionTip" runat="server" /></p>
                            </div>
                        </asp:PlaceHolder>
                        <p class="text-muted-cf" style="font-size:13px; margin-top:10px;">Compare this with your own answer, then tell us honestly:</p>
                        <div style="display:flex; gap:10px;">
                            <asp:Button ID="btnGotItRight" runat="server" Text="I got it right" CssClass="btn-cf btn-cf-primary btn-cf-sm" OnClick="btnGotItRight_Click" CausesValidation="false" />
                            <asp:Button ID="btnGotItWrong" runat="server" Text="I need more practice" CssClass="btn-cf btn-cf-ghost btn-cf-sm" OnClick="btnGotItWrong_Click" CausesValidation="false" />
                        </div>
                    </asp:PlaceHolder>

                    <asp:Literal ID="litOutcome" runat="server" />
                </div>
            </div>
        </div>
    </asp:PlaceHolder>

</asp:Content>
