<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ModuleLessons.aspx.cs" Inherits="Student_ModuleLessons" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Module</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Student/Roadmap.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> All modules</a>

    <div style="margin: 14px 0 24px 0;">
        <span class="pill pill-blue">Module <asp:Literal ID="litModuleOrder" runat="server" /></span>
        <h1 style="font-size: 26px; margin-top: 10px;"><asp:Literal ID="litModuleTitle" runat="server" /></h1>
        <p class="text-muted-cf"><asp:Literal ID="litModuleDescription" runat="server" /></p>
        <div class="cf-progress" style="max-width:340px; margin-top:10px;"><span id="barModule" runat="server" /></div>
        <p class="text-muted-cf" style="font-size:13px; margin-top:6px;"><asp:Literal ID="litModuleSummary" runat="server" /></p>
    </div>

    <div class="roadmap" style="max-width: 720px;">
        <asp:Repeater ID="rptLessons" runat="server">
            <ItemTemplate>
                <div class='roadmap-item <%# (bool)Eval("IsCompleted") ? "done" : (Eval("IsCurrent").ToString() == "True" ? "current" : "") %>'>
                    <div class="roadmap-num">
                        <%# (bool)Eval("IsCompleted") ? "<i class=\"fa-solid fa-check\"></i>" : Eval("Position") %>
                    </div>
                    <a href='<%# "~/Student/Lesson.aspx?id=" + Eval("LessonID") %>' runat="server" class="cf-card cf-card-sm" style="display:flex; justify-content:space-between; align-items:center; color:var(--text);">
                        <div>
                            <strong><%# Eval("Title") %></strong>
                            <div class="text-muted-cf" style="font-size:12.5px; margin-top:3px;"><%# Eval("ShortDescription") %></div>
                        </div>
                        <span class='pill <%# (bool)Eval("IsCompleted") ? "pill-green" : "pill-muted" %>'>
                            <%# (bool)Eval("IsCompleted") ? "Completed" : "Open" %>
                        </span>
                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal ID="litEmpty" runat="server" Visible="false" Text="<p class='text-muted-cf'>No lessons published in this module yet.</p>" />
    </div>

</asp:Content>
