<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Lessons.aspx.cs" Inherits="Admin_Lessons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Lessons</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h1 style="font-size:26px;">Lessons</h1>
    <p class="text-muted-cf">Pick a module, then add or edit its lessons. Changes appear to students immediately — no code changes needed.</p>

    <div class="cf-card mb-4">
        <div class="cf-field" style="margin-bottom:0;">
            <label>Module</label>
            <asp:DropDownList ID="ddlModuleFilter" runat="server" CssClass="cf-select" AutoPostBack="true" OnSelectedIndexChanged="ddlModuleFilter_SelectedIndexChanged" />
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;"><asp:Literal ID="litFormTitle" runat="server" Text="Add lesson" /></h3>
                <asp:Literal ID="litMessage" runat="server" />
                <asp:HiddenField ID="hfLessonId" runat="server" Value="0" />

                <div class="cf-field"><label>Module</label>
                    <asp:DropDownList ID="ddlModule" runat="server" CssClass="cf-select" />
                </div>
                <div class="row g-2">
                    <div class="col-6 cf-field"><label>Lesson order</label><asp:TextBox ID="txtDisplayOrder" runat="server" CssClass="cf-input" /></div>
                    <div class="col-6 cf-field"><label>Code language</label>
                        <asp:DropDownList ID="ddlCodeLanguage" runat="server" CssClass="cf-select">
                            <asp:ListItem Text="C#" Value="CSharp" />
                            <asp:ListItem Text="ASPX" Value="ASPX" />
                            <asp:ListItem Text="SQL" Value="SQL" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="cf-field"><label>Title</label><asp:TextBox ID="txtTitle" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Short description</label><asp:TextBox ID="txtShortDescription" runat="server" CssClass="cf-input" /></div>
                <div class="cf-field"><label>Learning objectives (one per line)</label><asp:TextBox ID="txtObjectives" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="3" /></div>
                <div class="cf-field"><label>Explanation</label><asp:TextBox ID="txtExplanation" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="4" /></div>
                <div class="cf-field"><label>Syntax</label><asp:TextBox ID="txtSyntax" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Code example</label><asp:TextBox ID="txtCodeExample" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="4" /></div>
                <div class="cf-field"><label>Line-by-line code explanation (one per line)</label><asp:TextBox ID="txtCodeExplanation" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="3" /></div>
                <div class="cf-field"><label>Expected output</label><asp:TextBox ID="txtExpectedOutput" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Real-world use</label><asp:TextBox ID="txtRealWorldUse" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Common mistakes (one per line)</label><asp:TextBox ID="txtCommonMistakes" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Troubleshooting tips (one per line)</label><asp:TextBox ID="txtTroubleshooting" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Key points (one per line)</label><asp:TextBox ID="txtKeyPoints" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><label>Practice task</label><asp:TextBox ID="txtPracticeTask" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="2" /></div>
                <div class="cf-field"><asp:CheckBox ID="chkPublished" runat="server" Text="Published" Checked="true" /></div>

                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="LessonForm" />

                <div style="display:flex; gap:10px; margin-top:10px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save lesson" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnSave_Click" ValidationGroup="LessonForm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cf btn-cf-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="cf-card" style="overflow-x:auto;">
                <asp:GridView ID="gvLessons" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvLessons_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="DisplayOrder" HeaderText="#" />
                        <asp:BoundField DataField="Title" HeaderText="Title" />
                        <asp:TemplateField HeaderText="Published">
                            <ItemTemplate><span class='pill <%# (bool)Eval("IsPublished") ? "pill-green" : "pill-muted" %>'><%# (bool)Eval("IsPublished") ? "Yes" : "No" %></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditLesson" CommandArgument='<%# Eval("LessonID") %>' CssClass="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                <a href='<%# "~/Admin/LessonQuiz.aspx?lessonId=" + Eval("LessonID") %>' runat="server" class="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-list-check"></i></a>
                                <asp:LinkButton runat="server" CommandName="DeleteLesson" CommandArgument='<%# Eval("LessonID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"
                                    OnClientClick="return confirm('Delete this lesson? This also removes student progress for it.');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate><p class="text-muted-cf" style="padding:16px 0; margin:0;">No lessons in this module yet.</p></EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
