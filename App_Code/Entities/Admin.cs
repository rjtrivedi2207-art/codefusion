using System;

namespace CodeFusion.Entities
{
    public class Admin
    {
        public int AdminID { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
