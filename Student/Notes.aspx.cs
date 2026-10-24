using System;
using System.Data;
using CodeFusion.BLL;

public partial class Student_Notes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            BindLessonDropdown();
            BindNotes();
        }
    }

    private void BindLessonDropdown()
    {
        var roadmap = LessonBLL.GetRoadmap(AuthBLL.CurrentStudentId());
        foreach (var lesson in roadmap)
            ddlLesson.Items.Add(new System.Web.UI.WebControls.ListItem(lesson.Title, lesson.LessonID.ToString()));
    }

    private void BindNotes()
    {
        DataTable dt = NoteBLL.GetForStudent(AuthBLL.CurrentStudentId());
        rptNotes.DataSource = dt;
        rptNotes.DataBind();
        litEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int studentId = AuthBLL.CurrentStudentId();
        int noteId = Convert.ToInt32(hfNoteId.Value);
        int? lessonId = string.IsNullOrEmpty(ddlLesson.SelectedValue) ? (int?)null : Convert.ToInt32(ddlLesson.SelectedValue);

        if (noteId == 0)
            NoteBLL.Create(studentId, lessonId, txtNote.Text.Trim());
        else
            NoteBLL.Update(noteId, studentId, txtNote.Text.Trim());

        ResetForm();
        BindNotes();
    }

    protected void rptNotes_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        int noteId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "DeleteNote")
        {
            NoteBLL.Delete(noteId, AuthBLL.CurrentStudentId());
            BindNotes();
        }
        else if (e.CommandName == "EditNote")
        {
            DataTable dt = NoteBLL.GetForStudent(AuthBLL.CurrentStudentId());
            foreach (DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["NoteID"]) == noteId)
                {
                    hfNoteId.Value = noteId.ToString();
                    txtNote.Text = row["NoteText"].ToString();
                    ddlLesson.SelectedValue = row["LessonID"] == DBNull.Value ? "" : row["LessonID"].ToString();
                    litFormTitle.Text = "Edit note";
                    btnSave.Text = "Update note";
                    btnCancel.Visible = true;
                    break;
                }
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hfNoteId.Value = "0";
        txtNote.Text = string.Empty;
        ddlLesson.SelectedIndex = 0;
        litFormTitle.Text = "New note";
        btnSave.Text = "Save note";
        btnCancel.Visible = false;
    }
}
