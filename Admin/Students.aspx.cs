using System;
using CodeFusion.BLL;

public partial class Admin_Students : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            BindGrid(string.Empty);
        }
    }

    private void BindGrid(string search)
    {
        gvStudents.DataSource = AdminBLL.SearchStudents(search);
        gvStudents.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtSearch.Text.Trim());
    }

    protected void gvStudents_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int studentId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "Deactivate")
        {
            AdminBLL.SetStudentActive(studentId, false);
        }
        else if (e.CommandName == "Activate")
        {
            AdminBLL.SetStudentActive(studentId, true);
        }

        BindGrid(txtSearch.Text.Trim());
    }
}
