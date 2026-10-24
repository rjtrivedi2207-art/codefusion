<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Roadmap.aspx.cs" Inherits="Student_Roadmap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Learning</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 24px;">
        <span class="pill pill-blue"><i class="fa-solid fa-route"></i> Learning</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Learning Modules</h1>
        <p class="text-muted-cf">Five modules, in order, from first principles to a complete debugging workflow.</p>
        <div class="cf-progress" style="max-width:340px; margin-top:10px;"><span id="barOverall" runat="server" /></div>
        <p class="text-muted-cf" style="font-size:13px; margin-top:6px;"><asp:Literal ID="litOverallSummary" runat="server" /></p>
    </div>

    <div class="grid-auto">
        <asp:Repeater ID="rptModules" runat="server">
            <ItemTemplate>
                <div class="cf-card">
                    <span class="pill pill-blue">Module <%# Eval("ModuleOrder") %></span>
                    <h3 style="font-size:17px; margin-top:12px;"><%# Eval("ModuleTitle") %></h3>
                    <p class="text-muted-cf" style="font-size:13.5px;"><%# Eval("Description") %></p>

                    <div style="display:flex; justify-content:space-between; font-size:12.5px; margin-bottom:6px;">
                        <span class="text-muted-cf"><%# Eval("CompletedLessonCount") %> / <%# Eval("LessonCount") %> lessons</span>
                        <span class="text-muted-cf"><%# Eval("CompletionPercent") %>%</span>
                    </div>
                    <div class="cf-progress thin green"><span style='width:<%# Eval("CompletionPercent") %>%' /></div>

                    <a href='<%# "~/Student/ModuleLessons.aspx?id=" + Eval("ModuleID") %>' runat="server" class="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" style="margin-top:14px;">
                        <%# (int)Eval("CompletedLessonCount") == 0 ? "Start Module" : ((int)Eval("CompletedLessonCount") == (int)Eval("LessonCount") && (int)Eval("LessonCount") > 0 ? "Review Module" : "Continue Module") %>
                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

</asp:Content>
