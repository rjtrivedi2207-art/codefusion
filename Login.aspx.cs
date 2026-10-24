using System;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (AuthBLL.IsStudentLoggedIn())
        {
            Response.Redirect("~/Student/Dashboard.aspx");
            return;
        }

        if (!IsPostBack && Request.QueryString["registered"] == "1")
        {
            litInfo.Text = "<div class='pill pill-green' style='margin-bottom:16px; display:inline-flex;'>" +
                            "<i class='fa-solid fa-check'></i>&nbsp; Account created — log in to continue</div><br/>";
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        Student student = AuthBLL.LoginStudent(txtEmail.Text.Trim(), txtPassword.Text);

        if (student == null)
        {
            litServerError.Text = "<div class='field-error' style='margin-bottom:14px;'>" +
                                   "Incorrect email or password.</div>";
            return;
        }

        Response.Redirect("~/Student/Dashboard.aspx");
    }
}
