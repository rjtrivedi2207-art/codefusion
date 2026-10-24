using System;
using CodeFusion.BLL;

public partial class Admin_Results : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            gvResults.DataSource = AdminBLL.GetAllResults();
            gvResults.DataBind();
        }
    }
}
