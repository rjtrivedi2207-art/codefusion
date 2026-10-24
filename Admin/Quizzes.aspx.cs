using System;
using CodeFusion.BLL;

public partial class Admin_Quizzes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        gvQuizzes.DataSource = AdminBLL.GetAllQuizzesRaw();
        gvQuizzes.DataBind();
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int timeLimit;
        int.TryParse(txtTimeLimit.Text.Trim(), out timeLimit);
        if (timeLimit <= 0) timeLimit = 10;

        AdminBLL.CreateQuiz(txtTitle.Text.Trim(), ddlType.SelectedValue, txtTopic.Text.Trim(), timeLimit);

        litMessage.Text = "<div class='pill pill-green mb-2'>Quiz created — add questions from the Questions page.</div>";
        txtTitle.Text = string.Empty;
        txtTopic.Text = string.Empty;
        txtTimeLimit.Text = "10";
        BindGrid();
    }

    protected void gvQuizzes_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int quizId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "Activate") AdminBLL.ToggleQuizActive(quizId, true);
        else if (e.CommandName == "Deactivate") AdminBLL.ToggleQuizActive(quizId, false);
        else if (e.CommandName == "DeleteQuiz") AdminBLL.DeleteQuiz(quizId);

        BindGrid();
    }
}
