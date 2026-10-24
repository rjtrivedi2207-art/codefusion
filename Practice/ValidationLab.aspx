<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ValidationLab.aspx.cs" Inherits="Practice_ValidationLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Validation Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Practice/Index.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Practice Lab</a>
    <div style="margin: 14px 0 24px 0;">
        <span class="pill pill-amber"><i class="fa-solid fa-shield-halved"></i> Validation Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Validation Lab</h1>
        <p class="text-muted-cf">One form, six validator types — submit with empty or invalid fields to see each one fire.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="cf-card">
                <asp:ValidationSummary ID="valSummary" runat="server" CssClass="field-error" DisplayMode="BulletList" HeaderText="Please fix the following:" ValidationGroup="ValLab" />
                <asp:Literal ID="litSuccess" runat="server" />

                <div class="cf-field">
                    <label>Username <span class="text-muted-cf">(RequiredFieldValidator)</span></label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="cf-input" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="Username is required." Display="Dynamic" CssClass="field-error" ValidationGroup="ValLab" />
                </div>

                <div class="cf-field">
                    <label>Password <span class="text-muted-cf">(RegularExpressionValidator)</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="cf-input" TextMode="Password" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                        ValidationExpression="^(?=.*[A-Za-z])(?=.*\d).{6,}$"
                        ErrorMessage="Password needs 6+ characters with at least one letter and one number."
                        Display="Dynamic" CssClass="field-error" ValidationGroup="ValLab" />
                </div>

                <div class="cf-field">
                    <label>Confirm password <span class="text-muted-cf">(CompareValidator)</span></label>
                    <asp:TextBox ID="txtConfirm" runat="server" CssClass="cf-input" TextMode="Password" />
                    <asp:CompareValidator ID="cvConfirm" runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match." Display="Dynamic" CssClass="field-error" ValidationGroup="ValLab" />
                </div>

                <div class="cf-field">
                    <label>Age <span class="text-muted-cf">(RangeValidator, 13–100)</span></label>
                    <asp:TextBox ID="txtAge" runat="server" CssClass="cf-input" />
                    <asp:RangeValidator ID="rvAge" runat="server" ControlToValidate="txtAge" Type="Integer"
                        MinimumValue="13" MaximumValue="100" ErrorMessage="Age must be between 13 and 100."
                        Display="Dynamic" CssClass="field-error" ValidationGroup="ValLab" />
                </div>

                <div class="cf-field">
                    <label>Favorite number (must be even) <span class="text-muted-cf">(CustomValidator)</span></label>
                    <asp:TextBox ID="txtEvenNumber" runat="server" CssClass="cf-input" />
                    <asp:CustomValidator ID="cvEven" runat="server" ControlToValidate="txtEvenNumber"
                        OnServerValidate="cvEven_ServerValidate" ErrorMessage="Please enter an even number."
                        Display="Dynamic" CssClass="field-error" ValidationGroup="ValLab" />
                </div>

                <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn-cf btn-cf-primary btn-cf-block" OnClick="btnSubmit_Click" ValidationGroup="ValLab" />
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cf-card">
                <h3 style="font-size:15px;">CustomValidator behind the scenes</h3>
                <p class="text-muted-cf" style="font-size:13px;">The five built-in validators need no code-behind at all — only CustomValidator does, because "even number" isn't a built-in rule:</p>
                <div class="code-block">protected void cvEven_ServerValidate(object source, ServerValidateEventArgs args)
{
    int number;
    args.IsValid = int.TryParse(args.Value, out number) && number % 2 == 0;
}</div>
                <p class="text-muted-cf" style="font-size:13px; margin-top:14px;">
                    <strong>Why check <code>Page.IsValid</code> in code-behind too?</strong><br/>
                    Client-side JavaScript validation can be bypassed (disabled JS, direct POST).
                    ASP.NET automatically re-runs every validator on the server, and
                    <code>Page.IsValid</code> reflects that server-side result — always check it
                    before acting on submitted data.
                </p>
            </div>
        </div>
    </div>

</asp:Content>
