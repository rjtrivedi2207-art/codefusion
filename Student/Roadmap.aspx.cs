using System;
using System.Collections.Generic;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_Roadmap : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            int studentId = AuthBLL.CurrentStudentId();
            List<Module> modules = ModuleBLL.GetActiveModules(studentId);

            int totalLessons = 0, totalDone = 0;
            foreach (Module m in modules) { totalLessons += m.LessonCount; totalDone += m.CompletedLessonCount; }
            int overallPct = totalLessons == 0 ? 0 : (int)Math.Round(totalDone * 100.0 / totalLessons);

            barOverall.Attributes["style"] = "width:" + overallPct + "%";
            litOverallSummary.Text = totalDone + " / " + totalLessons + " lessons complete (" + overallPct + "%)";

            rptModules.DataSource = modules;
            rptModules.DataBind();
        }
    }
}
