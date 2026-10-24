<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Notes.aspx.cs" Inherits="Student_Notes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">My Notes</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom:20px;">
        <span class="pill pill-green"><i class="fa-solid fa-note-sticky"></i> My Notes</span>
        <h1 style="font-size:26px; margin-top:10px;">My Notes</h1>
        <p class="text-muted-cf">Personal notes, optionally tied to a lesson.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="cf-card">
                <h3 style="font-size:16px;"><asp:Literal ID="litFormTitle" runat="server" Text="New note" /></h3>
                <asp:HiddenField ID="hfNoteId" runat="server" Value="0" />
                <div class="cf-field">
                    <label>Lesson (optional)</label>
                    <asp:DropDownList ID="ddlLesson" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="(General note)" Value="" />
                    </asp:DropDownList>
                </div>
                <div class="cf-field">
                    <label>Note</label>
                    <asp:TextBox ID="txtNote" runat="server" CssClass="cf-input" TextMode="MultiLine" Rows="5" />
                    <asp:RequiredFieldValidator ID="rfvNote" runat="server" ControlToValidate="txtNote" ErrorMessage="Note text is required." Display="Dynamic" CssClass="field-error" ValidationGroup="NoteForm" />
                </div>
                <div style="display:flex; gap:10px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save note" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnSave_Click" ValidationGroup="NoteForm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cf btn-cf-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <asp:Repeater ID="rptNotes" runat="server" OnItemCommand="rptNotes_ItemCommand">
                <ItemTemplate>
                    <div class="cf-card mb-3">
                        <div style="display:flex; justify-content:space-between;">
                            <span class="pill pill-muted"><%# Eval("LessonTitle") ?? "General" %></span>
                            <span class="text-muted-cf" style="font-size:12px;"><%# Eval("CreatedOn", "{0:dd MMM yyyy}") %></span>
                        </div>
                        <p style="margin:12px 0 10px 0; font-size:14px;"><%# Eval("NoteText") %></p>
                        <div style="display:flex; gap:8px;">
                            <asp:LinkButton runat="server" CommandName="EditNote" CommandArgument='<%# Eval("NoteID") %>' CssClass="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-pen"></i> Edit</asp:LinkButton>
                            <asp:LinkButton runat="server" CommandName="DeleteNote" CommandArgument='<%# Eval("NoteID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm"><i class="fa-solid fa-trash"></i> Delete</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Literal ID="litEmpty" runat="server" Visible="false" Text="<p class='text-muted-cf'>No notes yet.</p>" />
        </div>
    </div>

</asp:Content>
