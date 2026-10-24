<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="DropDownLab.aspx.cs" Inherits="Practice_DropDownLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">DropDownList Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Practice/Index.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Practice Lab</a>
    <div style="margin: 14px 0 24px 0;">
        <span class="pill pill-green"><i class="fa-solid fa-layer-group"></i> DropDownList Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Cascading DropDownList Lab</h1>
        <p class="text-muted-cf">Selecting a Country repopulates State; selecting a State repopulates City — each dropdown posts back and rebinds the next.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="cf-card">
                <div class="cf-field">
                    <label>Country</label>
                    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="cf-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged" />
                </div>
                <div class="cf-field">
                    <label>State</label>
                    <asp:DropDownList ID="ddlState" runat="server" CssClass="cf-select" AutoPostBack="true" OnSelectedIndexChanged="ddlState_SelectedIndexChanged" />
                </div>
                <div class="cf-field">
                    <label>City</label>
                    <asp:DropDownList ID="ddlCity" runat="server" CssClass="cf-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged" />
                </div>
                <div class="cf-card cf-card-sm" style="background:var(--bg-alt);">
                    Selected: <strong><asp:Literal ID="litSelection" runat="server" Text="—" /></strong>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">How it's wired</h3>
                <div class="code-block">protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
{
    ddlState.DataSource = LocationData.States[ddlCountry.SelectedValue];
    ddlState.DataBind();
    ddlCity.Items.Clear(); // reset the dependent dropdown
}</div>
                <p class="text-muted-cf" style="font-size:13px; margin-top:14px; margin-bottom:0;">
                    <code>AutoPostBack="true"</code> makes the dropdown fire its
                    <code>SelectedIndexChanged</code> event immediately, without waiting for a
                    Submit button — that's what makes the cascade feel instant.
                </p>
            </div>
        </div>
    </div>

</asp:Content>
