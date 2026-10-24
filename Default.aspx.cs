using System;
using CodeFusion.BLL;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            rptRoadmapPreview.DataSource = ModuleBLL.GetActiveModules(0);
            rptRoadmapPreview.DataBind();
        }
    }
}
