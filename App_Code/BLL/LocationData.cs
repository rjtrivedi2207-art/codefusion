using System.Collections.Generic;

namespace CodeFusion.BLL
{
    /// <summary>
    /// In-memory demo data for the cascading DropDownList Lab. A real app would
    /// pull this from a database, but the point of this lab is the cascading
    /// DataBind()/AutoPostBack pattern itself, so static data keeps the focus there.
    /// </summary>
    public static class LocationData
    {
        public static Dictionary<string, List<string>> States = new Dictionary<string, List<string>>
        {
            { "India", new List<string> { "Gujarat", "Maharashtra", "Karnataka" } },
            { "USA",   new List<string> { "California", "Texas", "New York" } },
            { "UK",    new List<string> { "England", "Scotland", "Wales" } }
        };

        public static Dictionary<string, List<string>> Cities = new Dictionary<string, List<string>>
        {
            { "Gujarat", new List<string> { "Surat", "Ahmedabad", "Vadodara" } },
            { "Maharashtra", new List<string> { "Mumbai", "Pune", "Nagpur" } },
            { "Karnataka", new List<string> { "Bengaluru", "Mysuru", "Hubballi" } },
            { "California", new List<string> { "Los Angeles", "San Francisco", "San Diego" } },
            { "Texas", new List<string> { "Houston", "Austin", "Dallas" } },
            { "New York", new List<string> { "New York City", "Buffalo", "Albany" } },
            { "England", new List<string> { "London", "Manchester", "Liverpool" } },
            { "Scotland", new List<string> { "Edinburgh", "Glasgow", "Aberdeen" } },
            { "Wales", new List<string> { "Cardiff", "Swansea", "Newport" } }
        };

        public static List<string> Countries { get { return new List<string>(States.Keys); } }
    }
}
