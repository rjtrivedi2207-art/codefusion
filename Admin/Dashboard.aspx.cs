using System;
using CodeFusion.BLL;

public partial class Admin_Dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            litAdminName.Text = System.Web.HttpUtility.HtmlEncode(AuthBLL.CurrentAdminName());

            AdminDashboardStats stats = AdminBLL.GetDashboardStats();
            litStudents.Text = stats.TotalStudents.ToString();
            litModules.Text = stats.TotalModules.ToString();
            litLessons.Text = stats.TotalLessons.ToString();
            litMaterials.Text = stats.TotalMaterials.ToString();
            litQuizzes.Text = stats.TotalQuizzes.ToString();
            litQuestions.Text = stats.TotalQuestions.ToString();
            litChallenges.Text = stats.TotalChallenges.ToString();
            litAttempts.Text = stats.TotalAttempts.ToString();
            litEmployees.Text = stats.TotalEmployees.ToString();
        }
    }
}
