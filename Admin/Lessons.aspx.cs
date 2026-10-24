using System;
using System.Data;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Admin_Lessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            BindModuleDropdowns();
            if (ddlModuleFilter.Items.Count > 0)
                BindGrid(Convert.ToInt32(ddlModuleFilter.SelectedValue));
        }
    }

    private void BindModuleDropdowns()
    {
        DataTable modules = ModuleBLL.GetAllModulesRaw();

        ddlModuleFilter.DataTextField = "ModuleTitle";
        ddlModuleFilter.DataValueField = "ModuleID";
        ddlModuleFilter.DataSource = modules;
        ddlModuleFilter.DataBind();

        ddlModule.DataTextField = "ModuleTitle";
        ddlModule.DataValueField = "ModuleID";
        ddlModule.DataSource = modules.Copy();
        ddlModule.DataBind();
    }

    private int CurrentModuleId()
    {
        int id;
        return int.TryParse(ddlModuleFilter.SelectedValue, out id) ? id : 0;
    }

    private void BindGrid(int moduleId)
    {
        gvLessons.DataSource = LessonBLL.GetLessonsForModuleRaw(moduleId);
        gvLessons.DataBind();
    }

    protected void ddlModuleFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        ResetForm();
        BindGrid(CurrentModuleId());
    }

    private static string JoinLines(string multilineText)
    {
        if (string.IsNullOrWhiteSpace(multilineText)) return string.Empty;
        string[] lines = multilineText.Replace("\r\n", "\n").Split('\n');
        return string.Join("|", lines);
    }

    private static string SplitToLines(string pipeSeparated)
    {
        if (string.IsNullOrWhiteSpace(pipeSeparated)) return string.Empty;
        return string.Join(Environment.NewLine, pipeSeparated.Split('|'));
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int lessonId = Convert.ToInt32(hfLessonId.Value);
        int moduleId = Convert.ToInt32(ddlModule.SelectedValue);
        int displayOrder;
        int.TryParse(txtDisplayOrder.Text.Trim(), out displayOrder);

        LessonBLL.SaveLesson(
            lessonId, moduleId, txtTitle.Text.Trim(), txtShortDescription.Text.Trim(),
            JoinLines(txtObjectives.Text), txtExplanation.Text.Trim(), txtSyntax.Text.Trim(), txtCodeExample.Text.Trim(),
            JoinLines(txtCodeExplanation.Text), txtExpectedOutput.Text.Trim(), txtRealWorldUse.Text.Trim(),
            JoinLines(txtCommonMistakes.Text), JoinLines(txtTroubleshooting.Text), JoinLines(txtKeyPoints.Text),
            txtPracticeTask.Text.Trim(), ddlCodeLanguage.SelectedValue, displayOrder, chkPublished.Checked);

        litMessage.Text = "<div class='pill pill-green mb-2'>Lesson saved.</div>";
        ResetForm();
        ddlModuleFilter.SelectedValue = moduleId.ToString();
        BindGrid(moduleId);
    }

    protected void gvLessons_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int lessonId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditLesson")
        {
            Lesson lesson = LessonBLL.GetById(lessonId, 0);
            if (lesson == null) return;

            hfLessonId.Value = lesson.LessonID.ToString();
            ddlModule.SelectedValue = lesson.ModuleID.ToString();
            txtDisplayOrder.Text = lesson.DisplayOrder.ToString();
            ddlCodeLanguage.SelectedValue = string.IsNullOrEmpty(lesson.CodeLanguage) ? "CSharp" : lesson.CodeLanguage;
            txtTitle.Text = lesson.Title;
            txtShortDescription.Text = lesson.ShortDescription;
            txtObjectives.Text = SplitToLines(lesson.LearningObjectives);
            txtExplanation.Text = lesson.Explanation;
            txtSyntax.Text = lesson.Syntax;
            txtCodeExample.Text = lesson.CodeExample;
            txtCodeExplanation.Text = SplitToLines(lesson.CodeExplanation);
            txtExpectedOutput.Text = lesson.ExpectedOutput;
            txtRealWorldUse.Text = lesson.RealWorldUse;
            txtCommonMistakes.Text = SplitToLines(lesson.CommonMistakes);
            txtTroubleshooting.Text = SplitToLines(lesson.Troubleshooting);
            txtKeyPoints.Text = SplitToLines(lesson.KeyPoints);
            txtPracticeTask.Text = lesson.PracticeTask;
            chkPublished.Checked = lesson.IsPublished;

            litFormTitle.Text = "Edit lesson #" + lesson.LessonID;
            btnSave.Text = "Update lesson";
            btnCancel.Visible = true;
        }
        else if (e.CommandName == "DeleteLesson")
        {
            LessonBLL.DeleteLesson(lessonId);
            litMessage.Text = "<div class='pill pill-amber mb-2'>Lesson deleted.</div>";
            ResetForm();
            BindGrid(CurrentModuleId());
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hfLessonId.Value = "0";
        if (ddlModuleFilter.Items.Count > 0) ddlModule.SelectedValue = ddlModuleFilter.SelectedValue;
        txtDisplayOrder.Text = string.Empty;
        ddlCodeLanguage.SelectedIndex = 0;
        txtTitle.Text = string.Empty;
        txtShortDescription.Text = string.Empty;
        txtObjectives.Text = string.Empty;
        txtExplanation.Text = string.Empty;
        txtSyntax.Text = string.Empty;
        txtCodeExample.Text = string.Empty;
        txtCodeExplanation.Text = string.Empty;
        txtExpectedOutput.Text = string.Empty;
        txtRealWorldUse.Text = string.Empty;
        txtCommonMistakes.Text = string.Empty;
        txtTroubleshooting.Text = string.Empty;
        txtKeyPoints.Text = string.Empty;
        txtPracticeTask.Text = string.Empty;
        chkPublished.Checked = true;
        litFormTitle.Text = "Add lesson";
        btnSave.Text = "Save lesson";
        btnCancel.Visible = false;
    }
}
