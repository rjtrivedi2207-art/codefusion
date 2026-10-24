<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ControlsLab.aspx.cs" Inherits="Practice_ControlsLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Controls Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Practice/Index.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Practice Lab</a>
    <div style="margin: 14px 0 24px 0;">
        <span class="pill pill-violet"><i class="fa-solid fa-sliders"></i> Controls Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">ASP.NET Controls Lab</h1>
        <p class="text-muted-cf">Every control below is live on this page — try it, then read how it's wired up.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">Label, TextBox &amp; Button</h3>
                <p class="text-muted-cf" style="font-size:13px;">Type something and click the button — the Label updates via a server-side Click event.</p>
                <asp:TextBox ID="txtEcho" runat="server" CssClass="cf-input" placeholder="Type here..." />
                <asp:Button ID="btnEcho" runat="server" Text="Show in Label" CssClass="btn-cf btn-cf-ghost btn-cf-sm mt-2" OnClick="btnEcho_Click" />
                <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);">
                    You typed: <asp:Label ID="lblEcho" runat="server" Text="(nothing yet)" style="color:var(--blue); font-weight:600;" />
                </div>
                <div class="code-block mt-2">protected void btnEcho_Click(object sender, EventArgs e)
{
    lblEcho.Text = txtEcho.Text;
}</div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">CheckBox &amp; RadioButtonList</h3>
                <p class="text-muted-cf" style="font-size:13px;">Selections are read from .Checked / .SelectedValue in code-behind.</p>
                <asp:CheckBox ID="chkSubscribe" runat="server" Text="Subscribe to updates" />
                <br /><br />
                <asp:RadioButtonList ID="rblLevel" runat="server">
                    <asp:ListItem Text="Beginner" Value="Beginner" Selected="True" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced" Value="Advanced" />
                </asp:RadioButtonList>
                <asp:Button ID="btnCheckDemo" runat="server" Text="Read selections" CssClass="btn-cf btn-cf-ghost btn-cf-sm mt-2" OnClick="btnCheckDemo_Click" />
                <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litCheckResult" runat="server" Text="Result appears here" /></div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">DropDownList &amp; ListBox</h3>
                <p class="text-muted-cf" style="font-size:13px;">Both bind to the same list of ASP.NET topics — one single-select, one multi-select.</p>
                <div class="cf-field"><asp:DropDownList ID="ddlTopic" runat="server" CssClass="cf-select" /></div>
                <div class="cf-field"><asp:ListBox ID="lbxTopics" runat="server" CssClass="cf-select" SelectionMode="Multiple" Rows="4" /></div>
                <asp:Button ID="btnListDemo" runat="server" Text="Read selections" CssClass="btn-cf btn-cf-ghost btn-cf-sm" OnClick="btnListDemo_Click" />
                <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litListResult" runat="server" Text="Result appears here" /></div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">Calendar</h3>
                <p class="text-muted-cf" style="font-size:13px;">Pick a date — SelectionChanged fires a server-side event.</p>
                <asp:Calendar ID="calDemo" runat="server" OnSelectionChanged="calDemo_SelectionChanged"
                    BackColor="#0F1729" ForeColor="#E8ECF6" BorderColor="#212D48"
                    SelectedDayStyle-BackColor="#4F7CFF" TitleStyle-BackColor="#131C33" style="border-radius:10px; overflow:hidden;" />
                <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);">Selected: <asp:Literal ID="litCalendarResult" runat="server" Text="(none yet)" /></div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">FileUpload</h3>
                <p class="text-muted-cf" style="font-size:13px;">Demonstrates reading the selected file's name and size (nothing is actually uploaded in this demo).</p>
                <asp:FileUpload ID="fuDemo" runat="server" CssClass="cf-input" />
                <asp:Button ID="btnUploadDemo" runat="server" Text="Inspect file" CssClass="btn-cf btn-cf-ghost btn-cf-sm mt-2" OnClick="btnUploadDemo_Click" CausesValidation="false" />
                <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litUploadResult" runat="server" Text="Result appears here" /></div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">GridView</h3>
                <p class="text-muted-cf" style="font-size:13px;">Bound to a small in-memory DataTable — the same pattern the CRUD Lab uses with real SQL Server data.</p>
                <asp:GridView ID="gvDemo" runat="server" AutoGenerateColumns="true" CssClass="table table-dark table-sm" GridLines="None" />
            </div>
        </div>
    </div>

</asp:Content>
