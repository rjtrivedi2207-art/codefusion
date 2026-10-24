using System;

namespace CodeFusion.Entities
{
    /// <summary>Plain data holder for a Lesson row (one item within a Module).</summary>
    public class Lesson
    {
        public int LessonID { get; set; }
        public int ModuleID { get; set; }
        public string Title { get; set; }
        public string ShortDescription { get; set; }
        public string LearningObjectives { get; set; }   // pipe-separated
        public string Explanation { get; set; }
        public string Syntax { get; set; }
        public string CodeExample { get; set; }
        public string CodeExplanation { get; set; }       // pipe-separated, one bullet per line of code
        public string ExpectedOutput { get; set; }
        public string RealWorldUse { get; set; }
        public string CommonMistakes { get; set; }        // pipe-separated
        public string Troubleshooting { get; set; }        // pipe-separated
        public string KeyPoints { get; set; }               // pipe-separated
        public string PracticeTask { get; set; }
        public string CodeLanguage { get; set; }             // CSharp / ASPX / SQL
        public int DisplayOrder { get; set; }
        public bool IsPublished { get; set; }
        public DateTime CreatedDate { get; set; }

        // Populated by LessonBLL for the current student, not stored on this table
        public bool IsCompleted { get; set; }

        // Populated via JOIN, not stored on this table
        public string ModuleTitle { get; set; }
        public int ModuleOrder { get; set; }
    }
}
