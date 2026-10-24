<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Quizzes.aspx.cs" Inherits="Admin_Quizzes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Quizzes</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Quizzes</h1>
    <p class="text-muted-cf">Create a quiz here, then manage its questions on the Questions page.</p>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="cf-card">
                <h3 style="font-size:16px;">New quiz</h3>
                <asp:Literal ID="litMessage" runat="server" />
                <div class="cf-field"><label>Title</label><asp:TextBox ID="txtTitle" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field">
                    <label>Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="Quick Quiz" Value="Quick" />
                        <asp:ListItem Text="Topic Quiz" Value="Topic" />
                        <asp:ListItem Text="Mock Test" Value="Mock" />
                        <asp:ListItem Text="Challenge Quiz" Value="Challenge" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field"><label>Topic</label><asp:TextBox ID="txtTopic" runat="server" CssClass="cf-input" placeholder="e.g. C# Fundamentals" /></div>
                <div class="cf-field"><label>Time limit (minutes)</label><asp:TextBox ID="txtTimeLimit" runat="server" CssClass="cf-input" Text="10" /></div>
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="QuizForm" />
                <asp:Button ID="btnCreate" runat="server" Text="Create quiz" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnCreate_Click" ValidationGroup="QuizForm" />
            </div>
        </div>

        <div class="col-lg-8">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvQuizzes" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvQuizzes_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Title" HeaderText="Title" />
                        <asp:BoundField DataField="QuizType" HeaderText="Type" />
                        <asp:BoundField DataField="QCount" HeaderText="Questions" />
                        <asp:TemplateField HeaderText="Active">
                            <ItemTemplate><span class='pill <%# (bool)Eval("IsActive") ? "pill-green" : "pill-muted" %>'><%# (bool)Eval("IsActive") ? "Yes" : "No" %></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='<%# "~/Admin/Questions.aspx?quizId=" + Eval("QuizID") %>' runat="server" class="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-list-check"></i> Questions</a>
                                <asp:LinkButton runat="server" CommandName='<%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>' CommandArgument='<%# Eval("QuizID") %>' CssClass="btn-cf btn-cf-ghost btn-cf-sm">
                                    <%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this quiz and all its questions/results?');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
