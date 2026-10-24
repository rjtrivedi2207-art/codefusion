using System;
using CodeFusion.BLL;

public partial class Admin_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (AuthBLL.IsAdminLoggedIn())
            Response.Redirect("~/Admin/Dashboard.aspx");
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        var admin = AuthBLL.LoginAdmin(txtEmail.Text.Trim(), txtPassword.Text);
        if (admin == null)
        {
            litServerError.Text = "<div class='field-error' style='margin-bottom:14px;'>Incorrect email or password.</div>";
            return;
        }

        Response.Redirect("~/Admin/Dashboard.aspx");
    }
}
