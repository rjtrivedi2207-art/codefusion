using System;
using CodeFusion.BLL;

public partial class Practice_Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
    }
}
