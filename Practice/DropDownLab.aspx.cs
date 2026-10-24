using System;
using CodeFusion.BLL;

public partial class Practice_DropDownLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AuthBLL.RequireStudent(Response);

        if (!IsPostBack)
        {
            ddlCountry.DataSource = LocationData.Countries;
            ddlCountry.DataBind();
            BindStates(ddlCountry.SelectedValue);
            BindCities(ddlState.SelectedValue);
            UpdateSelectionText();
        }
    }

    private void BindStates(string country)
    {
        ddlState.Items.Clear();
        if (LocationData.States.ContainsKey(country))
        {
            ddlState.DataSource = LocationData.States[country];
            ddlState.DataBind();
        }
    }

    private void BindCities(string state)
    {
        ddlCity.Items.Clear();
        if (LocationData.Cities.ContainsKey(state))
        {
            ddlCity.DataSource = LocationData.Cities[state];
            ddlCity.DataBind();
        }
    }

    private void UpdateSelectionText()
    {
        litSelection.Text = Server.HtmlEncode(ddlCity.SelectedValue + ", " + ddlState.SelectedValue + ", " + ddlCountry.SelectedValue);
    }

    protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindStates(ddlCountry.SelectedValue);
        BindCities(ddlState.SelectedValue);
        UpdateSelectionText();
    }

    protected void ddlState_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindCities(ddlState.SelectedValue);
        UpdateSelectionText();
    }

    protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdateSelectionText();
    }
}
