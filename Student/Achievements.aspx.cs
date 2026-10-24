using System;
using System.Collections.Generic;
using CodeFusion.BLL;

public partial class Student_Achievements : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            int studentId = AuthBLL.CurrentStudentId();
            List<AchievementItem> badges = AchievementBLL.GetForStudent(studentId);

            int unlockedCount = badges.FindAll(b => b.IsUnlocked).Count;
            litCount.Text = unlockedCount + " of " + badges.Count + " unlocked.";

            rptBadges.DataSource = badges;
            rptBadges.DataBind();
        }
    }
}
