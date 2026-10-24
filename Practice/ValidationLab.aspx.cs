using System;
using CodeFusion.BLL;

public partial class Practice_ValidationLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
    }

    protected void cvEven_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
    {
        int number;
        args.IsValid = int.TryParse(args.Value, out number) && number % 2 == 0;
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        litSuccess.Text = "<div class='pill pill-green' style='margin-bottom:16px; display:inline-flex;'>" +
                           "<i class='fa-solid fa-check'></i>&nbsp; All validators passed!</div><br/>";
    }
}
