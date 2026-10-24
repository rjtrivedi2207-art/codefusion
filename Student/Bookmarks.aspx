<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Bookmarks.aspx.cs" Inherits="Student_Bookmarks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">My Bookmarks</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom:20px;">
        <span class="pill pill-violet"><i class="fa-solid fa-bookmark"></i> My Bookmarks</span>
        <h1 style="font-size:26px; margin-top:10px;">My Bookmarks</h1>
        <p class="text-muted-cf">Lessons, materials and challenges you've saved for later.</p>
    </div>

    <div class="cf-card">
        <asp:Repeater ID="rptBookmarks" runat="server" OnItemCommand="rptBookmarks_ItemCommand">
            <ItemTemplate>
                <div style="display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid var(--border);">
                    <div>
                        <span class="pill pill-muted"><%# Eval("ItemType") %></span>
                        <strong style="margin-left:8px;"><%# Eval("Title") %></strong>
                    </div>
                    <asp:LinkButton runat="server" CommandName="Remove" CommandArgument='<%# Eval("BookmarkID") %>' CssClass="btn-cf btn-cf-danger btn-cf-sm">
                        <i class="fa-solid fa-trash"></i>
                    </asp:LinkButton>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Literal ID="litEmpty" runat="server" Visible="false" Text="<p class='text-muted-cf' style='padding:12px 0; margin:0;'>No bookmarks yet — save a lesson or material to see it here.</p>" />
    </div>

</asp:Content>
