using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CodeFusion.BLL;

public partial class Student_QuizTake : System.Web.UI.Page
{
    private int _quizId;

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!int.TryParse(Request.QueryString["id"], out _quizId))
        {
            Response.Redirect("~/Student/QuizArena.aspx");
            return;
        }

        if (!IsPostBack)
        {
            litQuizTitle.Text = Server.HtmlEncode(QuizBLL.GetQuizTitle(_quizId));
            List<QuizQuestion> questions = QuizBLL.GetQuestions(_quizId);

            if (questions.Count == 0)
            {
                Response.Redirect("~/Student/QuizArena.aspx");
                return;
            }

            ViewState["QuizId"] = _quizId;
            rptQuestions.DataSource = questions;
            rptQuestions.DataBind();
        }
        else
        {
            _quizId = ViewState["QuizId"] == null ? _quizId : Convert.ToInt32(ViewState["QuizId"]);
        }
    }

    protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;

        var question = (QuizQuestion)e.Item.DataItem;
        var rbl = (RadioButtonList)e.Item.FindControl("rblOptions");

        rbl.Items.Add(new ListItem(question.OptionA, "A"));
        rbl.Items.Add(new ListItem(question.OptionB, "B"));
        rbl.Items.Add(new ListItem(question.OptionC, "C"));
        rbl.Items.Add(new ListItem(question.OptionD, "D"));
    }

    protected void btnSubmitQuiz_Click(object sender, EventArgs e)
    {
        var answers = new Dictionary<int, string>();

        foreach (RepeaterItem item in rptQuestions.Items)
        {
            var rbl = (RadioButtonList)item.FindControl("rblOptions");
            var hfId = (HiddenField)item.FindControl("hfQuestionId");
            int questionId = Convert.ToInt32(hfId.Value);

            if (rbl.SelectedItem != null)
                answers[questionId] = rbl.SelectedValue;
        }

        int elapsed;
        int.TryParse(hfElapsedSeconds.Value, out elapsed);

        QuizResultSummary result = QuizBLL.Submit(AuthBLL.CurrentStudentId(), _quizId, answers, elapsed);

        Session["LastQuizResult"] = result;
        Session["LastQuizTitle"] = QuizBLL.GetQuizTitle(_quizId);
        Response.Redirect("~/Student/QuizResult.aspx");
    }
}
