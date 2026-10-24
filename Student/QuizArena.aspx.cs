using System;
using CodeFusion.BLL;

public partial class Student_QuizArena : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            var quizzes = QuizBLL.GetAllActive();
            rptQuizzes.DataSource = quizzes;
            rptQuizzes.DataBind();
            litEmpty.Visible = quizzes.Count == 0;
        }
    }
}
