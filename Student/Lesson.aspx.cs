using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_Lesson : System.Web.UI.Page
{
    private int _lessonId;
    public int ModuleIdForBackLink { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!int.TryParse(Request.QueryString["id"], out _lessonId))
        {
            Response.Redirect("~/Student/Roadmap.aspx");
            return;
        }

        if (!IsPostBack)
        {
            BindLesson();
            BindMiniQuiz();
        }
        else
        {
            // ModuleIdForBackLink is used by the markup's back-link even on postback.
            Lesson lesson = LessonBLL.GetById(_lessonId, AuthBLL.CurrentStudentId());
            if (lesson != null) ModuleIdForBackLink = lesson.ModuleID;
        }
    }

    private static List<string> SplitPipe(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return new List<string>();
        return new List<string>(value.Split('|'));
    }

    private void BindLesson()
    {
        int studentId = AuthBLL.CurrentStudentId();
        Lesson lesson = LessonBLL.GetById(_lessonId, studentId);

        if (lesson == null)
        {
            Response.Redirect("~/Student/Roadmap.aspx");
            return;
        }

        ModuleIdForBackLink = lesson.ModuleID;

        litModuleTitle.Text = Server.HtmlEncode(lesson.ModuleTitle);
        litTitle.Text = Server.HtmlEncode(lesson.Title);
        litShortDescription.Text = Server.HtmlEncode(lesson.ShortDescription);
        litExplanation.Text = Server.HtmlEncode(lesson.Explanation);
        litSyntax.Text = Server.HtmlEncode(lesson.Syntax);
        litCodeExample.Text = Server.HtmlEncode(lesson.CodeExample);
        litCodeLanguage.Text = string.IsNullOrEmpty(lesson.CodeLanguage) ? "Code" : lesson.CodeLanguage;
        litExpectedOutput.Text = Server.HtmlEncode(lesson.ExpectedOutput);
        litRealWorldUse.Text = Server.HtmlEncode(lesson.RealWorldUse);
        litPracticeTask.Text = Server.HtmlEncode(lesson.PracticeTask);

        rptObjectives.DataSource = SplitPipe(lesson.LearningObjectives);
        rptObjectives.DataBind();

        rptCodeExplanation.DataSource = SplitPipe(lesson.CodeExplanation);
        rptCodeExplanation.DataBind();

        rptKeyPoints.DataSource = SplitPipe(lesson.KeyPoints);
        rptKeyPoints.DataBind();

        rptMistakes.DataSource = SplitPipe(lesson.CommonMistakes);
        rptMistakes.DataBind();

        rptTroubleshooting.DataSource = SplitPipe(lesson.Troubleshooting);
        rptTroubleshooting.DataBind();

        if (lesson.IsCompleted)
        {
            btnMarkComplete.Visible = false;
            litAlreadyDone.Visible = true;
            litAlreadyDone.Text = "<span class='pill pill-green'><i class=\"fa-solid fa-check\"></i> Completed</span>";
        }

        // "Up next" — scoped within this lesson's own module.
        List<Lesson> moduleLessons = LessonBLL.GetLessonsForModule(lesson.ModuleID, studentId);
        int idx = moduleLessons.FindIndex(l => l.LessonID == lesson.LessonID);
        if (idx >= 0 && idx < moduleLessons.Count - 1)
        {
            Lesson next = moduleLessons[idx + 1];
            litNextLink.Text = "<a href='" + ResolveUrl("~/Student/Lesson.aspx") + "?id=" + next.LessonID + "' " +
                                "style='display:block; margin-top:10px; font-size:14px;'>" +
                                Server.HtmlEncode(next.Title) + " <i class='fa-solid fa-arrow-right'></i></a>";
        }
        else
        {
            litNextLink.Text = "<p class='text-muted-cf' style='font-size:13.5px; margin-top:10px;'>" +
                                "That's the last lesson in this module — nice work.</p>" +
                                "<a href='" + ResolveUrl("~/Student/ModuleLessons.aspx") + "?id=" + lesson.ModuleID + "' " +
                                "class='btn-cf btn-cf-ghost btn-cf-sm btn-cf-block' style='margin-top:10px;'>Back to module</a>";
        }
    }

    private void BindMiniQuiz()
    {
        List<LessonQuizQuestion> questions = LessonQuizBLL.GetForLesson(_lessonId);
        miniQuizCard.Visible = questions.Count > 0;

        if (questions.Count > 0)
        {
            rptMiniQuiz.DataSource = questions;
            rptMiniQuiz.DataBind();

            // RadioButtonList items can't use <%# %> binding (ListItem has no DataBinding event),
            // so populate each one here via ItemDataBound-equivalent manual loop.
            for (int i = 0; i < rptMiniQuiz.Items.Count; i++)
            {
                var rbl = (RadioButtonList)rptMiniQuiz.Items[i].FindControl("rblMiniQuiz");
                LessonQuizQuestion q = questions[i];
                rbl.Items.Add(new ListItem(q.OptionA, "A"));
                rbl.Items.Add(new ListItem(q.OptionB, "B"));
                rbl.Items.Add(new ListItem(q.OptionC, "C"));
                rbl.Items.Add(new ListItem(q.OptionD, "D"));
            }
        }
    }

    protected void btnMarkComplete_Click(object sender, EventArgs e)
    {
        LessonBLL.MarkComplete(AuthBLL.CurrentStudentId(), _lessonId);
        BindLesson();
        BindMiniQuiz();
    }

    protected void btnCheckQuiz_Click(object sender, EventArgs e)
    {
        List<LessonQuizQuestion> questions = LessonQuizBLL.GetForLesson(_lessonId);
        var answers = new Dictionary<int, string>();

        foreach (RepeaterItem item in rptMiniQuiz.Items)
        {
            var rbl = (RadioButtonList)item.FindControl("rblMiniQuiz");
            var hfId = (HiddenField)item.FindControl("hfMiniQuestionId");
            int questionId = Convert.ToInt32(hfId.Value);

            if (rbl.SelectedItem != null)
                answers[questionId] = rbl.SelectedValue;
        }

        int correct = LessonQuizBLL.Grade(questions, answers);
        litQuizResult.Text = "<div class='pill " + (correct == questions.Count ? "pill-green" : "pill-amber") +
                              "' style='margin-bottom:14px; display:inline-flex;'>" +
                              "You got " + correct + " / " + questions.Count + " correct</div>";

        BindMiniQuiz();
    }
}
