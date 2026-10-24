using System;
using CodeFusion.BLL;

public partial class Admin_LessonQuiz : System.Web.UI.Page
{
    private int _lessonId;

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!int.TryParse(Request.QueryString["lessonId"], out _lessonId))
        {
            Response.Redirect("~/Admin/Lessons.aspx");
            return;
        }

        if (!IsPostBack)
        {
            var lesson = LessonBLL.GetById(_lessonId, 0);
            litLessonTitle.Text = lesson != null ? Server.HtmlEncode(lesson.Title) : "Unknown lesson";
            BindGrid();
        }
    }

    private void BindGrid()
    {
        gvQuestions.DataSource = LessonQuizBLL.GetForLesson(_lessonId);
        gvQuestions.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int order;
        int.TryParse(txtOrder.Text.Trim(), out order);
        if (order <= 0) order = 1;

        LessonQuizBLL.AddQuestion(_lessonId, txtQuestion.Text.Trim(), txtA.Text.Trim(), txtB.Text.Trim(),
            txtC.Text.Trim(), txtD.Text.Trim(), ddlCorrect.SelectedValue, order);

        litMessage.Text = "<div class='pill pill-green mb-2'>Question added.</div>";
        txtQuestion.Text = txtA.Text = txtB.Text = txtC.Text = txtD.Text = string.Empty;
        txtOrder.Text = "1";
        BindGrid();
    }

    protected void gvQuestions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteQuestion")
        {
            LessonQuizBLL.DeleteQuestion(Convert.ToInt32(e.CommandArgument));
            BindGrid();
        }
    }
}
