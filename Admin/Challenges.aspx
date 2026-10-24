<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Challenges.aspx.cs" Inherits="Admin_Challenges" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Challenges</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Debug Lab Challenges</h1>
    <p class="text-muted-cf">Add Find-the-Error, Complete-the-Code or Fix-the-Code challenges.</p>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;">Add challenge</h3>
                <asp:Literal ID="litMessage" runat="server" />
                <div class="cf-field">
                    <label>Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="Find the Error" Value="FindError" />
                        <asp:ListItem Text="Complete the Code" Value="CompleteCode" />
                        <asp:ListItem Text="Fix the Code" Value="FixCode" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field">
                    <label>Difficulty</label>
                    <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="Easy" Value="Easy" /><asp:ListItem Text="Medium" Value="Medium" /><asp:ListItem Text="Hard" Value="Hard" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="C# Error" Value="C# Error" />
                        <asp:ListItem Text="ASP.NET Error" Value="ASP.NET Error" />
                        <asp:ListItem Text="SQL Error" Value="SQL Error" />
                        <asp:ListItem Text="Database Connection Error" Value="Database Connection Error" />
                        <asp:ListItem Text="Web.config Error" Value="Web.config Error" />
                        <asp:ListItem Text="Control/Event Error" Value="Control/Event Error" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field"><label>Question</label><asp:TextBox ID="txtQuestion" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Code snippet</label><asp:TextBox ID="txtCode" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="4" /></div>
                <div class="cf-field"><label>Answer (short)</label><asp:TextBox ID="txtAnswer" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Hint 1</label><asp:TextBox ID="txtHint1" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Hint 2</label><asp:TextBox ID="txtHint2" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Full solution</label><asp:TextBox ID="txtSolution" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="4" /></div>
                <div class="cf-field"><label>Prevention tip</label><asp:TextBox ID="txtPreventionTip" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>XP reward</label><asp:TextBox ID="txtXp" runat="server" CssClass="cf-input" Text="20" /></div>

                <asp:RequiredFieldValidator ID="rfvQ" runat="server" ControlToValidate="txtQuestion" ErrorMessage="Question is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ChForm" />
                <asp:RequiredFieldValidator ID="rfvCode" runat="server" ControlToValidate="txtCode" ErrorMessage="Code snippet is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ChForm" />
                <asp:RequiredFieldValidator ID="rfvSolution" runat="server" ControlToValidate="txtSolution" ErrorMessage="Solution is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ChForm" />

                <asp:Button ID="btnAdd" runat="server" Text="Add challenge" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnAdd_Click" ValidationGroup="ChForm" />
            </div>
        </div>

        <div class="col-lg-7">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvChallenges" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvChallenges_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ChallengeType" HeaderText="Type" />
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="Difficulty" HeaderText="Difficulty" />
                        <asp:BoundField DataField="Question" HeaderText="Question" />
                        <asp:BoundField DataField="XPReward" HeaderText="XP" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="DeleteChallenge" CommandArgument='<%# Eval("ChallengeID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this challenge?');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
