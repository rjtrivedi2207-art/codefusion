using System;
using System.Collections.Generic;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_ModuleLessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        int moduleId;
        if (!int.TryParse(Request.QueryString["id"], out moduleId))
        {
            Response.Redirect("~/Student/Roadmap.aspx");
            return;
        }

        if (!IsPostBack)
        {
            int studentId = AuthBLL.CurrentStudentId();
            Module module = ModuleBLL.GetById(moduleId, studentId);
            if (module == null)
            {
                Response.Redirect("~/Student/Roadmap.aspx");
                return;
            }

            litModuleOrder.Text = module.ModuleOrder.ToString();
            litModuleTitle.Text = Server.HtmlEncode(module.ModuleTitle);
            litModuleDescription.Text = Server.HtmlEncode(module.Description);
            barModule.Attributes["style"] = "width:" + module.CompletionPercent + "%";
            litModuleSummary.Text = module.CompletedLessonCount + " / " + module.LessonCount + " lessons complete (" + module.CompletionPercent + "%)";

            List<Lesson> lessons = LessonBLL.GetLessonsForModule(moduleId, studentId);
            Lesson current = lessons.Find(l => !l.IsCompleted);

            var viewModel = new List<object>();
            int position = 1;
            foreach (Lesson l in lessons)
            {
                viewModel.Add(new
                {
                    l.LessonID,
                    l.Title,
                    l.ShortDescription,
                    l.IsCompleted,
                    Position = position,
                    IsCurrent = current != null && l.LessonID == current.LessonID
                });
                position++;
            }

            rptLessons.DataSource = viewModel;
            rptLessons.DataBind();
            litEmpty.Visible = lessons.Count == 0;
        }
    }
}
