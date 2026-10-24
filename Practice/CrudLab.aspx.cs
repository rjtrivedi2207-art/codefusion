using System;
using System.Globalization;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Practice_CrudLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        gvEmployees.DataSource = EmployeeBLL.GetAll();
        gvEmployees.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        var emp = new Employee
        {
            EmployeeID = Convert.ToInt32(hfEmployeeId.Value),
            Name = txtName.Text.Trim(),
            Email = txtEmail.Text.Trim(),
            Department = ddlDepartment.SelectedValue,
            Salary = decimal.Parse(txtSalary.Text.Trim(), CultureInfo.InvariantCulture)
        };

        string error = (emp.EmployeeID == 0) ? EmployeeBLL.Create(emp) : EmployeeBLL.Update(emp);

        if (error != string.Empty)
        {
            ShowMessage(error, isError: true);
            return;
        }

        if (Session["CrudXpAwarded"] == null)
        {
            StudentBLL.AddXP(AuthBLL.CurrentStudentId(), 15);
            Session["CrudXpAwarded"] = true;
            ShowMessage("Saved! +15 XP for your first CRUD Lab save this session.", isError: false);
        }
        else
        {
            ShowMessage("Employee saved.", isError: false);
        }

        ResetForm();
        BindGrid();
    }

    protected void gvEmployees_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditEmp")
        {
            Employee emp = EmployeeBLL.GetById(id);
            if (emp == null) return;

            hfEmployeeId.Value = emp.EmployeeID.ToString();
            txtName.Text = emp.Name;
            txtEmail.Text = emp.Email;
            ddlDepartment.SelectedValue = emp.Department;
            txtSalary.Text = emp.Salary.ToString(CultureInfo.InvariantCulture);

            litFormTitle.Text = "Edit employee #" + emp.EmployeeID;
            btnSave.Text = "Update employee";
            btnCancel.Visible = true;
        }
        else if (e.CommandName == "DeleteEmp")
        {
            EmployeeBLL.Delete(id);
            ShowMessage("Employee deleted.", isError: false);
            ResetForm();
            BindGrid();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hfEmployeeId.Value = "0";
        txtName.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtSalary.Text = string.Empty;
        ddlDepartment.SelectedIndex = 0;
        litFormTitle.Text = "Add employee";
        btnSave.Text = "Save employee";
        btnCancel.Visible = false;
    }

    private void ShowMessage(string text, bool isError)
    {
        string cssClass = isError ? "field-error" : "pill pill-green";
        litFormMessage.Text = "<div class='" + cssClass + "' style='margin-bottom:14px; display:block;'>" +
                               System.Web.HttpUtility.HtmlEncode(text) + "</div>";
    }
}
