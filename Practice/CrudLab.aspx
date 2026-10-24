<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="CrudLab.aspx.cs" Inherits="Practice_CrudLab" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">CRUD Lab</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="margin-bottom: 20px;">
        <span class="pill pill-violet"><i class="fa-solid fa-database"></i> CRUD Lab · Module 10</span>
        <h1 style="font-size: 26px; margin-top: 10px;">Employee CRUD Lab</h1>
        <p class="text-muted-cf">Full Create · Read · Update · Delete against a real SQL Server table, through the 3-tier architecture (Presentation → EmployeeBLL → DBHelper → SQL Server).</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="cf-card">
                <h3 style="font-size:16px;"><asp:Literal ID="litFormTitle" runat="server" Text="Add employee" /></h3>
                <asp:Literal ID="litFormMessage" runat="server" />

                <asp:HiddenField ID="hfEmployeeId" runat="server" Value="0" />

                <div class="cf-field">
                    <label>Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="cf-input" placeholder="Full name" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Name is required." Display="Dynamic" CssClass="field-error" ValidationGroup="EmployeeForm" />
                </div>

                <div class="cf-field">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="cf-input" placeholder="name@company.com" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." Display="Dynamic" CssClass="field-error" ValidationGroup="EmployeeForm" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email."
                        Display="Dynamic" CssClass="field-error" ValidationGroup="EmployeeForm" />
                </div>

                <div class="cf-field">
                    <label>Department</label>
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="cf-select">
                        <asp:ListItem Text="Engineering" Value="Engineering" />
                        <asp:ListItem Text="Design" Value="Design" />
                        <asp:ListItem Text="QA" Value="QA" />
                        <asp:ListItem Text="HR" Value="HR" />
                        <asp:ListItem Text="Sales" Value="Sales" />
                    </asp:DropDownList>
                </div>

                <div class="cf-field">
                    <label>Salary</label>
                    <asp:TextBox ID="txtSalary" runat="server" CssClass="cf-input" placeholder="e.g. 42000" />
                    <asp:RequiredFieldValidator ID="rfvSalary" runat="server" ControlToValidate="txtSalary"
                        ErrorMessage="Salary is required." Display="Dynamic" CssClass="field-error" ValidationGroup="EmployeeForm" />
                    <asp:RangeValidator ID="rvSalary" runat="server" ControlToValidate="txtSalary"
                        Type="Double" MinimumValue="1" MaximumValue="99999999" ErrorMessage="Enter a salary greater than 0."
                        Display="Dynamic" CssClass="field-error" ValidationGroup="EmployeeForm" />
                </div>

                <div style="display:flex; gap:10px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save employee" CssClass="btn-cf btn-cf-primary btn-cf-block"
                        OnClick="btnSave_Click" ValidationGroup="EmployeeForm" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cf btn-cf-ghost"
                        OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="cf-card" style="overflow-x:auto;">
                <h3 style="font-size:16px; margin-bottom:14px;">Employees</h3>
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="false" CssClass="table table-dark table-hover align-middle"
                    OnRowCommand="gvEmployees_RowCommand" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="EmployeeID" HeaderText="ID" />
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:BoundField DataField="Salary" HeaderText="Salary" DataFormatString="{0:C0}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditEmp" CommandArgument='<%# Eval("EmployeeID") %>'
                                    CssClass="btn-cf btn-cf-ghost btn-cf-sm" CausesValidation="false"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteEmp" CommandArgument='<%# Eval("EmployeeID") %>'
                                    CssClass="btn-cf btn-cf-danger btn-cf-sm" CausesValidation="false"
                                    OnClientClick="return confirm('Delete this employee?');"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p class="text-muted-cf" style="padding:16px 0; margin:0;">No employees yet — add one on the left.</p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
