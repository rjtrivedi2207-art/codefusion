using System;
using CodeFusion.BLL;

public partial class Student_QuizResult : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        var result = Session["LastQuizResult"] as QuizResultSummary;
        if (result == null)
        {
            // Nothing to show (e.g. page refreshed directly) — send them back to pick a quiz.
            Response.Redirect("~/Student/QuizArena.aspx");
            return;
        }

        litQuizTitle.Text = Server.HtmlEncode(Session["LastQuizTitle"] as string ?? "Quiz");
        litPercentage.Text = result.Percentage.ToString();
        litPerformanceMsg.Text = Server.HtmlEncode(result.PerformanceMessage);
        litScore.Text = result.Score + "/" + result.TotalMarks;
        litCorrect.Text = result.CorrectCount.ToString();
        litIncorrect.Text = result.IncorrectCount.ToString();

        int mins = result.TimeTakenSec / 60, secs = result.TimeTakenSec % 60;
        litTime.Text = mins + "m " + secs + "s";

        // Clear so a page refresh doesn't re-show a stale result.
        Session.Remove("LastQuizResult");
        Session.Remove("LastQuizTitle");
    }
}
