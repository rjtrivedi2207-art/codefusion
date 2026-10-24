using System;
using System.Collections.Generic;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_Progress : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            int studentId = AuthBLL.CurrentStudentId();
            DashboardStats stats = StudentBLL.GetDashboardStats(studentId);

            barCourse.Attributes["style"] = "width:" + stats.CompletionPercent + "%";
            litLessonsSummary.Text = stats.CompletedLessons + " of " + stats.TotalLessons + " lessons completed (" + stats.CompletionPercent + "%)";

            barQuiz.Attributes["style"] = "width:" + stats.QuizAveragePercent + "%";
            litQuizSummary.Text = "Average score across all attempts: " + stats.QuizAveragePercent + "%";

            litLessonsDone.Text = stats.CompletedLessons.ToString();
            litChallengesDone.Text = stats.CompletedChallenges.ToString();
            litBadgesCount.Text = stats.EarnedBadges.ToString();

            var history = QuizBLL.GetHistory(studentId);
            litQuizzesTaken.Text = history.Rows.Count.ToString();

            List<Module> modules = ModuleBLL.GetActiveModules(studentId);
            rptModules.DataSource = modules;
            rptModules.DataBind();
        }
    }
}
