<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="LessonQuiz.aspx.cs" Inherits="Admin_LessonQuiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Lesson Mini Quiz</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Admin/Lessons.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Lessons</a>
    <h1 style="font-size:26px; margin-top:10px;">Mini Quiz — <asp:Literal ID="litLessonTitle" runat="server" /></h1>
    <p class="text-muted-cf">3-5 quick questions shown directly on this lesson page, right before "Mark as completed".</p>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;">Add question</h3>
                <asp:Literal ID="litMessage" runat="server" />
                <div class="cf-field"><label>Question text</label><asp:TextBox ID="txtQuestion" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Option A</label><asp:TextBox ID="txtA" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Option B</label><asp:TextBox ID="txtB" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Option C</label><asp:TextBox ID="txtC" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Option D</label><asp:TextBox ID="txtD" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field">
                    <label>Correct option</label>
                    <asp:DropDownList ID="ddlCorrect" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="A" Value="A" /><asp:ListItem Text="B" Value="B" />
                        <asp:ListItem Text="C" Value="C" /><asp:ListItem Text="D" Value="D" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field"><label>Display order</label><asp:TextBox ID="txtOrder" runat="server" CssClass="cf-input" Text="1" /></div>

                <asp:RequiredFieldValidator ID="rfvQ" runat="server" ControlToValidate="txtQuestion" ErrorMessage="Question text is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LQForm" />
                <asp:RequiredFieldValidator ID="rfvA" runat="server" ControlToValidate="txtA" ErrorMessage="Option A is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LQForm" />
                <asp:RequiredFieldValidator ID="rfvB" runat="server" ControlToValidate="txtB" ErrorMessage="Option B is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LQForm" />
                <asp:RequiredFieldValidator ID="rfvC" runat="server" ControlToValidate="txtC" ErrorMessage="Option C is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LQForm" />
                <asp:RequiredFieldValidator ID="rfvD" runat="server" ControlToValidate="txtD" ErrorMessage="Option D is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LQForm" />

                <asp:Button ID="btnAdd" runat="server" Text="Add question" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnAdd_Click" ValidationGroup="LQForm" />
            </div>
        </div>

        <div class="col-lg-7">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvQuestions" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvQuestions_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="DisplayOrder" HeaderText="#" />
                        <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                        <asp:BoundField DataField="CorrectOption" HeaderText="Correct" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="DeleteQuestion" CommandArgument='<%# Eval("LessonQuizQuestionID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this question?');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate><p class="text-muted-cf" style="padding:16px 0; margin:0;">No mini-quiz questions yet — add one on the left.</p></EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
