using System;
using System.Data;
using CodeFusion.BLL;

public partial class Practice_ControlsLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);

        if (!IsPostBack)
        {
            string[] topics = { "ASP.NET Basics", "Web Forms", "C#", "Controls", "Validation", "Data Binding", "SQL Server", "CRUD" };

            ddlTopic.DataSource = topics;
            ddlTopic.DataBind();

            lbxTopics.DataSource = topics;
            lbxTopics.DataBind();

            BindDemoGrid();
        }
    }

    private void BindDemoGrid()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Control");
        dt.Columns.Add("Category");
        dt.Rows.Add("Label", "Display");
        dt.Rows.Add("TextBox", "Input");
        dt.Rows.Add("GridView", "Data");
        dt.Rows.Add("Calendar", "Input");
        gvDemo.DataSource = dt;
        gvDemo.DataBind();
    }

    protected void btnEcho_Click(object sender, EventArgs e)
    {
        lblEcho.Text = string.IsNullOrWhiteSpace(txtEcho.Text) ? "(nothing typed)" : Server.HtmlEncode(txtEcho.Text);
    }

    protected void btnCheckDemo_Click(object sender, EventArgs e)
    {
        litCheckResult.Text = "Subscribed: <strong>" + (chkSubscribe.Checked ? "Yes" : "No") +
                               "</strong> · Level: <strong>" + rblLevel.SelectedValue + "</strong>";
    }

    protected void btnListDemo_Click(object sender, EventArgs e)
    {
        var selected = new System.Collections.Generic.List<string>();
        foreach (System.Web.UI.WebControls.ListItem item in lbxTopics.Items)
            if (item.Selected) selected.Add(item.Text);

        litListResult.Text = "DropDownList: <strong>" + ddlTopic.SelectedValue + "</strong><br/>" +
                              "ListBox (multi): <strong>" + (selected.Count == 0 ? "(none selected)" : string.Join(", ", selected)) + "</strong>";
    }

    protected void calDemo_SelectionChanged(object sender, EventArgs e)
    {
        litCalendarResult.Text = calDemo.SelectedDate.ToString("dddd, MMMM d, yyyy");
    }

    protected void btnUploadDemo_Click(object sender, EventArgs e)
    {
        if (fuDemo.HasFile)
        {
            litUploadResult.Text = "File: <strong>" + Server.HtmlEncode(fuDemo.FileName) + "</strong> · " +
                                    Math.Round(fuDemo.PostedFile.ContentLength / 1024.0, 1) + " KB";
        }
        else
        {
            litUploadResult.Text = "No file selected.";
        }
    }
}
