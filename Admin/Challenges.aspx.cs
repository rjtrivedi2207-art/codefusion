using System;
using CodeFusion.BLL;

public partial class Admin_Challenges : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireAdmin(Response);
        if (!AuthBLL.IsAdminLoggedIn()) return;

        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    private void BindGrid()
    {
        gvChallenges.DataSource = ChallengeBLL.GetAll();
        gvChallenges.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int xp;
        int.TryParse(txtXp.Text.Trim(), out xp);
        if (xp <= 0) xp = 20;

        AdminBLL.AddChallenge(ddlType.SelectedValue, ddlCategory.SelectedValue, ddlDifficulty.SelectedValue, txtQuestion.Text.Trim(),
            txtCode.Text.Trim(), txtAnswer.Text.Trim(), txtHint1.Text.Trim(), txtHint2.Text.Trim(),
            txtSolution.Text.Trim(), txtPreventionTip.Text.Trim(), xp);

        litMessage.Text = "<div class='pill pill-green mb-2'>Challenge added.</div>";
        txtQuestion.Text = txtCode.Text = txtAnswer.Text = txtHint1.Text = txtHint2.Text = txtSolution.Text = txtPreventionTip.Text = string.Empty;
        txtXp.Text = "20";
        BindGrid();
    }

    protected void gvChallenges_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteChallenge")
        {
            AdminBLL.DeleteChallenge(Convert.ToInt32(e.CommandArgument));
            BindGrid();
        }
    }
}
