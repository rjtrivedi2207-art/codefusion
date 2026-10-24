using System;
using System.Collections.Generic;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_Dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            int studentId = AuthBLL.CurrentStudentId();
            Student student = StudentBLL.GetById(studentId);
            if (student == null) { AuthBLL.Logout(); Response.Redirect("~/Login.aspx"); return; }

            litName.Text = System.Web.HttpUtility.HtmlEncode(student.FullName.Split(' ')[0]);
            litStreak.Text = student.StreakDays.ToString();
            litXP.Text = student.XP.ToString();
            litLevel.Text = student.Level.ToString();
            barXP.Attributes["style"] = "width:" + StudentBLL.XpIntoCurrentLevel(student.XP) + "%";

            DashboardStats stats = StudentBLL.GetDashboardStats(studentId);
            litCompletionPct.Text = stats.CompletionPercent.ToString();
            barCompletion.Attributes["style"] = "width:" + stats.CompletionPercent + "%";
            litQuizAvg.Text = stats.QuizAveragePercent.ToString();
            litBadges.Text = stats.EarnedBadges.ToString();

            BindModuleSnapshot(studentId);

            List<ActivityItem> activity = StudentActivityBLL.GetRecent(studentId, 6);
            rptActivity.DataSource = activity;
            rptActivity.DataBind();
            litNoActivity.Visible = activity.Count == 0;
            if (activity.Count == 0)
                litNoActivity.Text = "<p class='text-muted-cf' style='font-size:13.5px; margin-top:10px;'>" +
                                      "No activity yet — complete a lesson to get started.</p>";
        }
    }

    private void BindModuleSnapshot(int studentId)
    {
        List<Module> modules = ModuleBLL.GetActiveModules(studentId);

        // "Currently on" = the first module that isn't 100% complete yet.
        Module currentModule = modules.Find(m => m.CompletionPercent < 100);
        litCurrentModule.Text = currentModule != null
            ? System.Web.HttpUtility.HtmlEncode(currentModule.ModuleTitle)
            : "All modules complete!";

        rptRoadmapSnapshot.DataSource = modules;
        rptRoadmapSnapshot.DataBind();
    }
}
