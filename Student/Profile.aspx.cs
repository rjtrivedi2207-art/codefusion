using System;
using CodeFusion.BLL;
using CodeFusion.Entities;

public partial class Student_Profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            Student student = StudentBLL.GetById(AuthBLL.CurrentStudentId());
            if (student == null) { Response.Redirect("~/Login.aspx"); return; }

            litInitial.Text = student.FullName.Trim()[0].ToString().ToUpper();
            litName.Text = Server.HtmlEncode(student.FullName);
            litEmail.Text = Server.HtmlEncode(student.Email);
            litXP.Text = student.XP.ToString();
            litLevel.Text = student.Level.ToString();
            litStreak.Text = student.StreakDays.ToString();
            litJoined.Text = student.CreatedOn.ToString("MMMM yyyy");
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        AuthBLL.Logout();
        Response.Redirect("~/Default.aspx");
    }
}
