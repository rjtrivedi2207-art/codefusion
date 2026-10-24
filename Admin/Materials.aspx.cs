using System;
using System.IO;
using CodeFusion.BLL;

public partial class Admin_Materials : System.Web.UI.Page
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
        gvMaterials.DataSource = MaterialBLL.Search(string.Empty, string.Empty);
        gvMaterials.DataBind();
    }

    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        bool isPdf = ddlType.SelectedValue == "PDF";
        phPdf.Visible = isPdf;
        phText.Visible = !isPdf;
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (ddlType.SelectedValue == "PDF")
        {
            if (!fuPdf.HasFile)
            {
                litMessage.Text = "<div class='field-error mb-2'>Please choose a PDF file to upload.</div>";
                return;
            }
            if (!fuPdf.FileName.ToLower().EndsWith(".pdf"))
            {
                litMessage.Text = "<div class='field-error mb-2'>Only .pdf files are allowed.</div>";
                return;
            }

            string uploadFolder = Server.MapPath("~/Uploads/Materials/");
            if (!Directory.Exists(uploadFolder)) Directory.CreateDirectory(uploadFolder);

            string safeFileName = Guid.NewGuid().ToString("N") + ".pdf";
            fuPdf.SaveAs(Path.Combine(uploadFolder, safeFileName));

            MaterialBLL.AddPdfMaterial(txtTitle.Text.Trim(), txtDescription.Text.Trim(), txtTopic.Text.Trim(),
                "~/Uploads/Materials/" + safeFileName);
        }
        else
        {
            MaterialBLL.AddTextMaterial(txtTitle.Text.Trim(), txtDescription.Text.Trim(), txtTopic.Text.Trim(), txtContent.Text.Trim());
        }

        litMessage.Text = "<div class='pill pill-green mb-2'>Material added.</div>";
        txtTitle.Text = txtDescription.Text = txtTopic.Text = string.Empty;
        BindGrid();
    }

    protected void gvMaterials_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteMaterial")
        {
            MaterialBLL.Delete(Convert.ToInt32(e.CommandArgument));
            BindGrid();
        }
    }
}
