using System;

namespace CodeFusion.Entities
{
    public class Student
    {
        public int StudentID { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public int XP { get; set; }
        public int Level { get; set; }
        public int StreakDays { get; set; }
        public DateTime? LastActiveDate { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
