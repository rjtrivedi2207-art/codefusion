using System;
using CodeFusion.BLL;

public partial class Student_QuizHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            gvHistory.DataSource = QuizBLL.GetHistory(AuthBLL.CurrentStudentId());
            gvHistory.DataBind();
        }
    }
}
