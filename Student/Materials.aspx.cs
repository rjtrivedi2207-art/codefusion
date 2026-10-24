using System;
using System.Data;
using CodeFusion.BLL;

public partial class Student_Materials : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        if (!IsPostBack)
        {
            BindTopics();
            BindMaterials(string.Empty, string.Empty);
        }
    }

    private void BindTopics()
    {
        DataTable topics = MaterialBLL.GetAllTopics();
        foreach (DataRow row in topics.Rows)
            ddlTopic.Items.Add(new System.Web.UI.WebControls.ListItem(row["Topic"].ToString(), row["Topic"].ToString()));
    }

    private void BindMaterials(string keyword, string topic)
    {
        DataTable dt = MaterialBLL.Search(keyword, topic);
        rptMaterials.DataSource = dt;
        rptMaterials.DataBind();
        litEmpty.Visible = dt.Rows.Count == 0;
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        BindMaterials(txtSearch.Text.Trim(), ddlTopic.SelectedValue);
    }

    protected void rptMaterials_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Bookmark")
        {
            string[] parts = e.CommandArgument.ToString().Split('|');
            int materialId = Convert.ToInt32(parts[0]);
            string title = parts.Length > 1 ? parts[1] : "Material";

            BookmarkBLL.Add(AuthBLL.CurrentStudentId(), "Material", materialId, title);
        }
    }
}
