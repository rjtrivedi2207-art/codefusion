using System;
using CodeFusion.BLL;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (AuthBLL.IsStudentLoggedIn())
            Response.Redirect("~/Student/Dashboard.aspx");
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string error = AuthBLL.RegisterStudent(
            txtFullName.Text.Trim(),
            txtEmail.Text.Trim(),
            txtPassword.Text);

        if (error != string.Empty)
        {
            litServerError.Text = "<div class='field-error' style='margin-bottom:14px;'>" +
                                   System.Web.HttpUtility.HtmlEncode(error) + "</div>";
            return;
        }

        Response.Redirect("~/Login.aspx?registered=1");
    }
}
