using System;
using CodeFusion.BLL;
using CodeFusion.DAL;

public partial class Utilities_SeedAdmin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // No auth guard on purpose — this page only works before any admin exists (see below),
        // which is what makes it safe to leave briefly during first-time setup.
    }

    protected void btnCreate_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int existingAdmins = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Admin"));
        if (existingAdmins > 0)
        {
            litMessage.Text = "<div class='field-error mb-2'>An admin account already exists. " +
                               "Delete this utility page — it will no longer create accounts.</div>";
            return;
        }

        string hash = PasswordHelper.Hash(txtPassword.Text);
        DBHelper.ExecuteInsertReturnId(
            "INSERT INTO Admin (FullName, Email, PasswordHash) VALUES (@Name, @Email, @Hash)",
            DBHelper.Param("@Name", txtName.Text.Trim()),
            DBHelper.Param("@Email", txtEmail.Text.Trim()),
            DBHelper.Param("@Hash", hash));

        litMessage.Text = "<div class='pill pill-green mb-2'><i class='fa-solid fa-check'></i> Admin account created. " +
                           "You can now log in at /Admin/Login.aspx — please delete this file now.</div>";
    }
}
