using System;
using CodeFusion.BLL;

public partial class Admin_Questions : System.Web.UI.Page
{
    private int _quizId;

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!int.TryParse(Request.QueryString["quizId"], out _quizId))
        {
            Response.Redirect("~/Admin/Quizzes.aspx");
            return;
        }

        if (!IsPostBack)
        {
            litQuizTitle.Text = Server.HtmlEncode(QuizBLL.GetQuizTitle(_quizId));
            BindGrid();
        }
        else
        {
            ViewState["QuizId"] = _quizId;
        }
    }

    private void BindGrid()
    {
        gvQuestions.DataSource = QuizBLL.GetQuestions(_quizId);
        gvQuestions.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int marks;
        int.TryParse(txtMarks.Text.Trim(), out marks);
        if (marks <= 0) marks = 1;

        AdminBLL.AddQuestion(_quizId, txtQuestion.Text.Trim(), txtA.Text.Trim(), txtB.Text.Trim(),
            txtC.Text.Trim(), txtD.Text.Trim(), ddlCorrect.SelectedValue, marks);

        litMessage.Text = "<div class='pill pill-green mb-2'>Question added.</div>";
        txtQuestion.Text = txtA.Text = txtB.Text = txtC.Text = txtD.Text = string.Empty;
        txtMarks.Text = "1";
        BindGrid();
    }

    protected void gvQuestions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteQuestion")
        {
            AdminBLL.DeleteQuestion(Convert.ToInt32(e.CommandArgument));
            BindGrid();
        }
    }
}
