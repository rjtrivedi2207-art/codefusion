using System;
using System.Globalization;
using CodeFusion.BLL;

public partial class Practice_ArithmeticLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);
    }

    private static double D(System.Web.UI.WebControls.TextBox tb)
    {
        return double.Parse(tb.Text.Trim(), CultureInfo.InvariantCulture);
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        litAddResult.Text = "Result: <strong>" + (D(txtAddA) + D(txtAddB)) + "</strong>";
    }

    protected void btnSub_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        litSubResult.Text = "Result: <strong>" + (D(txtSubA) - D(txtSubB)) + "</strong>";
    }

    protected void btnMul_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        litMulResult.Text = "Result: <strong>" + (D(txtMulA) * D(txtMulB)) + "</strong>";
    }

    protected void btnDiv_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double b = D(txtDivB);
        litDivResult.Text = (b == 0)
            ? "<span class='field-error'>Cannot divide by zero.</span>"
            : "Result: <strong>" + Math.Round(D(txtDivA) / b, 4) + "</strong>";
    }

    protected void btnPct_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double value = D(txtPctValue), pct = D(txtPctOf);
        litPctResult.Text = "Result: <strong>" + Math.Round(value * pct / 100.0, 2) + "</strong> (" + pct + "% of " + value + ")";
    }

    protected void btnSquare_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double n = D(txtPow);
        litPowResult.Text = "Square: <strong>" + (n * n) + "</strong>";
    }

    protected void btnCube_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double n = D(txtPow);
        litPowResult.Text = "Cube: <strong>" + (n * n * n) + "</strong>";
    }

    protected void btnBmi_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double weight = D(txtBmiWeight), height = D(txtBmiHeight);

        if (height <= 0)
        {
            litBmiResult.Text = "<span class='field-error'>Height must be greater than zero.</span>";
            return;
        }

        double bmi = Math.Round(weight / (height * height), 1);
        string category = bmi < 18.5 ? "Underweight" : bmi < 25 ? "Normal" : bmi < 30 ? "Overweight" : "Obese";
        litBmiResult.Text = "BMI: <strong>" + bmi + "</strong> — " + category;
    }

    protected void btnSi_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        double p = D(txtSiP), r = D(txtSiR), t = D(txtSiT);
        double si = Math.Round((p * r * t) / 100.0, 2);
        litSiResult.Text = "Simple Interest: <strong>" + si + "</strong> · Total: <strong>" + (p + si) + "</strong>";
    }
}
