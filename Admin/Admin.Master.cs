using System;
using CodeFusion.BLL;

public partial class AdminMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        litAdminName.Text = System.Web.HttpUtility.HtmlEncode(AuthBLL.CurrentAdminName());
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        AuthBLL.Logout();
        Response.Redirect("~/Admin/Login.aspx");
    }
}
