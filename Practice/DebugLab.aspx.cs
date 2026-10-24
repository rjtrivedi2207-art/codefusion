using System;
using System.Web.UI.WebControls;
using CodeFusion.BLL;

public partial class Practice_DebugLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
        if (!AuthBLL.IsStudentLoggedIn()) return;

        int challengeId;
        bool hasChallenge = int.TryParse(Request.QueryString["id"], out challengeId);

        if (!hasChallenge)
        {
            phList.Visible = true;
            phAttempt.Visible = false;
            if (!IsPostBack) BindList();
            return;
        }

        phList.Visible = false;
        phAttempt.Visible = true;

        if (!IsPostBack)
        {
            Session["DebugChallengeId"] = challengeId;
            Session["DebugHintsUsed"] = 0;
            BindChallenge(challengeId);
        }
    }

    private void BindList()
    {
        rptChallenges.DataSource = ChallengeBLL.GetAll();
        rptChallenges.DataBind();
    }

    protected string GetDifficultyPill(string difficulty)
    {
        switch (difficulty)
        {
            case "Easy": return "pill-green";
            case "Medium": return "pill-amber";
            default: return "pill-red";
        }
    }

    protected void rptChallenges_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "Open")
        {
            Response.Redirect("~/Practice/DebugLab.aspx?id=" + e.CommandArgument);
        }
    }

    private void BindChallenge(int challengeId)
    {
        ChallengeItem challenge = ChallengeBLL.GetById(challengeId);
        if (challenge == null)
        {
            Response.Redirect("~/Practice/DebugLab.aspx");
            return;
        }

        litType.Text = challenge.ChallengeType + " · " + challenge.Difficulty;
        litCategory.Text = string.IsNullOrEmpty(challenge.Category) ? "General" : challenge.Category;
        litQuestion.Text = Server.HtmlEncode(challenge.Question);
        litCode.Text = Server.HtmlEncode(challenge.CodeSnippet);
        litHint1.Text = "<div class='cf-card cf-card-sm mt-2' style='background:var(--bg-alt);'>" + Server.HtmlEncode(challenge.Hint1) + "</div>";
        litHint2.Text = "<div class='cf-card cf-card-sm mt-2' style='background:var(--bg-alt);'>" + Server.HtmlEncode(challenge.Hint2) + "</div>";
        litSolution.Text = Server.HtmlEncode(challenge.Solution);
        phPrevention.Visible = !string.IsNullOrEmpty(challenge.PreventionTip);
        litPreventionTip.Text = Server.HtmlEncode(challenge.PreventionTip);
    }

    private int CurrentChallengeId()
    {
        return Session["DebugChallengeId"] == null ? 0 : Convert.ToInt32(Session["DebugChallengeId"]);
    }

    private int HintsUsed()
    {
        return Session["DebugHintsUsed"] == null ? 0 : Convert.ToInt32(Session["DebugHintsUsed"]);
    }

    protected void btnHint1_Click(object sender, EventArgs e)
    {
        BindChallenge(CurrentChallengeId());
        litHint1.Visible = true;
        btnHint1.Enabled = false;
        Session["DebugHintsUsed"] = HintsUsed() + 1;
    }

    protected void btnHint2_Click(object sender, EventArgs e)
    {
        BindChallenge(CurrentChallengeId());
        litHint1.Visible = true; btnHint1.Enabled = false;
        litHint2.Visible = true;
        btnHint2.Enabled = false;
        Session["DebugHintsUsed"] = HintsUsed() + 1;
    }

    protected void btnReveal_Click(object sender, EventArgs e)
    {
        BindChallenge(CurrentChallengeId());
        phSolution.Visible = true;
    }

    protected void btnGotItRight_Click(object sender, EventArgs e)
    {
        RecordAndShowOutcome(true);
    }

    protected void btnGotItWrong_Click(object sender, EventArgs e)
    {
        RecordAndShowOutcome(false);
    }

    private void RecordAndShowOutcome(bool isCorrect)
    {
        int challengeId = CurrentChallengeId();
        BindChallenge(challengeId);
        phSolution.Visible = true;

        int xp = ChallengeBLL.RecordAttempt(AuthBLL.CurrentStudentId(), challengeId, isCorrect, HintsUsed());

        litOutcome.Text = isCorrect
            ? "<div class='pill pill-green mt-3' style='display:inline-flex;'><i class='fa-solid fa-check'></i>&nbsp; Nice work — +" + xp + " XP</div>"
            : "<div class='pill pill-amber mt-3' style='display:inline-flex;'><i class='fa-solid fa-rotate'></i>&nbsp; No XP this time — try another challenge to build the skill.</div>";

        btnGotItRight.Enabled = false;
        btnGotItWrong.Enabled = false;
    }
}
