using System;
using CodeFusion.BLL;

public partial class Admin_Modules : System.Web.UI.Page
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
        gvModules.DataSource = ModuleBLL.GetAllModulesRaw();
        gvModules.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int moduleId = Convert.ToInt32(hfModuleId.Value);
        int order = Convert.ToInt32(txtOrder.Text.Trim());

        ModuleBLL.SaveModule(moduleId, txtTitle.Text.Trim(), txtDescription.Text.Trim(), order, chkActive.Checked);

        litMessage.Text = "<div class='pill pill-green mb-2'>Module saved — it will appear on the student Learning page immediately.</div>";
        ResetForm();
        BindGrid();
    }

    protected void gvModules_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int moduleId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "EditModule")
        {
            var dt = ModuleBLL.GetAllModulesRaw();
            foreach (System.Data.DataRow row in dt.Rows)
            {
                if (Convert.ToInt32(row["ModuleID"]) == moduleId)
                {
                    hfModuleId.Value = moduleId.ToString();
                    txtTitle.Text = row["ModuleTitle"].ToString();
                    txtDescription.Text = row["Description"].ToString();
                    txtOrder.Text = row["ModuleOrder"].ToString();
                    chkActive.Checked = Convert.ToBoolean(row["IsActive"]);

                    litFormTitle.Text = "Edit module #" + moduleId;
                    btnSave.Text = "Update module";
                    btnCancel.Visible = true;
                    break;
                }
            }
        }
        else if (e.CommandName == "DeleteModule")
        {
            string error = ModuleBLL.DeleteModule(moduleId);
            litMessage.Text = error == string.Empty
                ? "<div class='pill pill-amber mb-2'>Module deleted.</div>"
                : "<div class='field-error mb-2'>" + Server.HtmlEncode(error) + "</div>";
            ResetForm();
            BindGrid();
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hfModuleId.Value = "0";
        txtTitle.Text = string.Empty;
        txtDescription.Text = string.Empty;
        txtOrder.Text = string.Empty;
        chkActive.Checked = true;
        litFormTitle.Text = "Add module";
        btnSave.Text = "Save module";
        btnCancel.Visible = false;
    }
}
