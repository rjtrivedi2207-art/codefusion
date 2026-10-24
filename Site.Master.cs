using System;
using CodeFusion.BLL;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bool loggedIn = AuthBLL.IsStudentLoggedIn();

        phStudentLinks.Visible = loggedIn;
        phStudentRight.Visible = loggedIn;
        phGuestLinks.Visible = !loggedIn;
        phGuestRight.Visible = !loggedIn;

        if (loggedIn)
        {
            string name = AuthBLL.CurrentStudentName();
            litAvatarInitial.Text = string.IsNullOrEmpty(name) ? "S" : name.Trim()[0].ToString().ToUpper();

            var student = CodeFusion.BLL.StudentBLL.GetById(AuthBLL.CurrentStudentId());
            litNavXP.Text = student != null ? student.XP.ToString() : "0";
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        AuthBLL.Logout();
        Response.Redirect("~/Default.aspx");
    }
}
