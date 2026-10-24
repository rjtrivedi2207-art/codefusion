<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ArithmeticLab.aspx.cs" Inherits="Practice_ArithmeticLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Arithmetic Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <a href="~/Practice/Index.aspx" runat="server" class="text-muted-cf" style="font-size:13.5px;"><i class="fa-solid fa-arrow-left"></i> Practice Lab</a>
    <div style="margin: 14px 0 24px 0;">
        <span class="pill pill-blue"><i class="fa-solid fa-calculator"></i> Arithmetic Lab</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Arithmetic Lab</h1>
        <p class="text-muted-cf">Each calculator posts back to the server, validates input with ASP.NET validators, and computes the result in code-behind.</p>
    </div>

    <div class="grid-auto">

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-plus" style="color:var(--blue);"></i> Addition</h3>
            <div class="cf-field"><asp:TextBox ID="txtAddA" runat="server" CssClass="cf-input" placeholder="Number A" /></div>
            <div class="cf-field"><asp:TextBox ID="txtAddB" runat="server" CssClass="cf-input" placeholder="Number B" /></div>
            <asp:CompareValidator ID="cvAddA" runat="server" ControlToValidate="txtAddA" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Add" />
            <asp:CompareValidator ID="cvAddB" runat="server" ControlToValidate="txtAddB" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Add" />
            <asp:Button ID="btnAdd" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnAdd_Click" ValidationGroup="Add" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litAddResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-minus" style="color:var(--blue);"></i> Subtraction</h3>
            <div class="cf-field"><asp:TextBox ID="txtSubA" runat="server" CssClass="cf-input" placeholder="Number A" /></div>
            <div class="cf-field"><asp:TextBox ID="txtSubB" runat="server" CssClass="cf-input" placeholder="Number B" /></div>
            <asp:CompareValidator ID="cvSubA" runat="server" ControlToValidate="txtSubA" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Sub" />
            <asp:CompareValidator ID="cvSubB" runat="server" ControlToValidate="txtSubB" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Sub" />
            <asp:Button ID="btnSub" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnSub_Click" ValidationGroup="Sub" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litSubResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-xmark" style="color:var(--blue);"></i> Multiplication</h3>
            <div class="cf-field"><asp:TextBox ID="txtMulA" runat="server" CssClass="cf-input" placeholder="Number A" /></div>
            <div class="cf-field"><asp:TextBox ID="txtMulB" runat="server" CssClass="cf-input" placeholder="Number B" /></div>
            <asp:CompareValidator ID="cvMulA" runat="server" ControlToValidate="txtMulA" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Mul" />
            <asp:CompareValidator ID="cvMulB" runat="server" ControlToValidate="txtMulB" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Mul" />
            <asp:Button ID="btnMul" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnMul_Click" ValidationGroup="Mul" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litMulResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-divide" style="color:var(--blue);"></i> Division</h3>
            <div class="cf-field"><asp:TextBox ID="txtDivA" runat="server" CssClass="cf-input" placeholder="Numerator" /></div>
            <div class="cf-field"><asp:TextBox ID="txtDivB" runat="server" CssClass="cf-input" placeholder="Denominator" /></div>
            <asp:CompareValidator ID="cvDivA" runat="server" ControlToValidate="txtDivA" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Div" />
            <asp:CompareValidator ID="cvDivB" runat="server" ControlToValidate="txtDivB" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Div" />
            <asp:Button ID="btnDiv" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnDiv_Click" ValidationGroup="Div" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litDivResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-percent" style="color:var(--violet);"></i> Percentage</h3>
            <div class="cf-field"><asp:TextBox ID="txtPctValue" runat="server" CssClass="cf-input" placeholder="Value" /></div>
            <div class="cf-field"><asp:TextBox ID="txtPctOf" runat="server" CssClass="cf-input" placeholder="Percent (%)" /></div>
            <asp:CompareValidator ID="cvPctValue" runat="server" ControlToValidate="txtPctValue" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Pct" />
            <asp:CompareValidator ID="cvPctOf" runat="server" ControlToValidate="txtPctOf" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Pct" />
            <asp:Button ID="btnPct" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnPct_Click" ValidationGroup="Pct" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litPctResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-superscript" style="color:var(--violet);"></i> Square &amp; Cube</h3>
            <div class="cf-field"><asp:TextBox ID="txtPow" runat="server" CssClass="cf-input" placeholder="Number" /></div>
            <asp:CompareValidator ID="cvPow" runat="server" ControlToValidate="txtPow" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Pow" />
            <div style="display:flex; gap:8px;">
                <asp:Button ID="btnSquare" runat="server" Text="Square" CssClass="btn-cf btn-cf-ghost btn-cf-sm" OnClick="btnSquare_Click" ValidationGroup="Pow" />
                <asp:Button ID="btnCube" runat="server" Text="Cube" CssClass="btn-cf btn-cf-ghost btn-cf-sm" OnClick="btnCube_Click" ValidationGroup="Pow" />
            </div>
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litPowResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-weight-scale" style="color:var(--green);"></i> BMI Calculator</h3>
            <div class="cf-field"><asp:TextBox ID="txtBmiWeight" runat="server" CssClass="cf-input" placeholder="Weight (kg)" /></div>
            <div class="cf-field"><asp:TextBox ID="txtBmiHeight" runat="server" CssClass="cf-input" placeholder="Height (m), e.g. 1.75" /></div>
            <asp:CompareValidator ID="cvBmiW" runat="server" ControlToValidate="txtBmiWeight" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Bmi" />
            <asp:CompareValidator ID="cvBmiH" runat="server" ControlToValidate="txtBmiHeight" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Bmi" />
            <asp:Button ID="btnBmi" runat="server" Text="Calculate BMI" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnBmi_Click" ValidationGroup="Bmi" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litBmiResult" runat="server" Text="Result appears here" /></div>
        </div>

        <div class="cf-card">
            <h3 style="font-size:15px;"><i class="fa-solid fa-coins" style="color:var(--green);"></i> Simple Interest</h3>
            <div class="cf-field"><asp:TextBox ID="txtSiP" runat="server" CssClass="cf-input" placeholder="Principal" /></div>
            <div class="cf-field"><asp:TextBox ID="txtSiR" runat="server" CssClass="cf-input" placeholder="Rate (%)" /></div>
            <div class="cf-field"><asp:TextBox ID="txtSiT" runat="server" CssClass="cf-input" placeholder="Time (years)" /></div>
            <asp:CompareValidator ID="cvSiP" runat="server" ControlToValidate="txtSiP" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Si" />
            <asp:CompareValidator ID="cvSiR" runat="server" ControlToValidate="txtSiR" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Si" />
            <asp:CompareValidator ID="cvSiT" runat="server" ControlToValidate="txtSiT" Operator="DataTypeCheck" Type="Double" ErrorMessage="Enter a valid number." Display="Dynamic" CssClass="field-error" ValidationGroup="Si" />
            <asp:Button ID="btnSi" runat="server" Text="Calculate" CssClass="btn-cf btn-cf-primary btn-cf-sm btn-cf-block" OnClick="btnSi_Click" ValidationGroup="Si" />
            <div class="cf-card cf-card-sm mt-2" style="background:var(--bg-alt);"><asp:Literal ID="litSiResult" runat="server" Text="Result appears here" /></div>
        </div>

    </div>

</asp:Content>
