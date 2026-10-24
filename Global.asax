
<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Register jQuery for ASP.NET Web Forms unobtrusive validation.
        ScriptResourceDefinition jquery = new ScriptResourceDefinition
        {
            Path = "~/Scripts/jquery-3.7.1.min.js",
            DebugPath = "~/Scripts/jquery-3.7.1.js",
            CdnPath = "https://code.jquery.com/jquery-3.7.1.min.js",
            CdnDebugPath = "https://code.jquery.com/jquery-3.7.1.js"
        };

        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", jquery);
    }

    void Session_Start(object sender, EventArgs e)
    {
        // A new session begins here.
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Application-level error handling.
    }

</script>
