using System;
using CodeFusion.BLL;

public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.Logout();
        Response.Redirect("~/Default.aspx");
    }
}
