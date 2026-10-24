using System;
using System.Data;
using CodeFusion.BLL;

public partial class Student_Bookmarks : System.Web.UI.Page
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
        DataTable dt = BookmarkBLL.GetForStudent(AuthBLL.CurrentStudentId());
        rptBookmarks.DataSource = dt;
        rptBookmarks.DataBind();
        litEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void rptBookmarks_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            BookmarkBLL.Remove(Convert.ToInt32(e.CommandArgument), AuthBLL.CurrentStudentId());
            BindGrid();
        }
    }
}
