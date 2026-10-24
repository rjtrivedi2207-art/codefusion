<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Materials.aspx.cs" Inherits="Student_Materials" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Study Materials</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom:20px;">
        <span class="pill pill-blue"><i class="fa-solid fa-book"></i> Study Materials</span>
        <h1 style="font-size:26px; margin-top:10px;">Study Materials</h1>
        <p class="text-muted-cf">Browse, search and bookmark supporting material for the roadmap.</p>
    </div>

    <div class="cf-card mb-3">
        <div class="row g-2">
            <div class="col-md-6"><asp:TextBox ID="txtSearch" runat="server" CssClass="cf-input" placeholder="Search materials..." /></div>
            <div class="col-md-4">
                <asp:DropDownList ID="ddlTopic" runat="server" CssClass="cf-select">
                    <asp:ListItem Text="All topics" Value="" />
                </asp:DropDownList>
            </div>
            <div class="col-md-2"><asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnFilter_Click" CausesValidation="false" /></div>
        </div>
    </div>

    <div class="grid-auto">
        <asp:Repeater ID="rptMaterials" runat="server" OnItemCommand="rptMaterials_ItemCommand">
            <ItemTemplate>
                <div class="cf-card">
                    <span class="pill pill-muted"><%# Eval("Topic") %></span>
                    <h3 style="font-size:15px; margin-top:12px;"><%# Eval("Title") %></h3>
                    <p class="text-muted-cf" style="font-size:13px;"><%# Eval("Description") %></p>
                    <div style="display:flex; gap:8px; flex-wrap:wrap;">
                        <asp:HyperLink runat="server" NavigateUrl='<%# Eval("FilePath") %>' Visible='<%# Eval("MaterialType").ToString() == "PDF" %>'
                            Target="_blank" CssClass="btn-cf btn-cf-ghost btn-cf-sm"><i class="fa-solid fa-file-pdf"></i> Open PDF</asp:HyperLink>
                        <asp:LinkButton runat="server" CommandName="Bookmark" CommandArgument='<%# Eval("MaterialID") + "|" + Eval("Title") %>' CssClass="btn-cf btn-cf-ghost btn-cf-sm">
                            <i class="fa-solid fa-bookmark"></i> Bookmark
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal ID="litEmpty" runat="server" Visible="false" Text="<p class='text-muted-cf'>No materials match your search.</p>" />
    </div>

</asp:Content>
