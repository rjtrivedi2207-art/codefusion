using System;

namespace CodeFusion.Entities
{
    /// <summary>Plain data holder for a Module row (one of the 5 top-level learning modules).</summary>
    public class Module
    {
        public int ModuleID { get; set; }
        public string ModuleTitle { get; set; }
        public string Description { get; set; }
        public int ModuleOrder { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        // Populated by ModuleBLL for the current student, not stored on this table
        public int LessonCount { get; set; }
        public int CompletedLessonCount { get; set; }
        public int CompletionPercent
        {
            get { return LessonCount == 0 ? 0 : (int)Math.Round(CompletedLessonCount * 100.0 / LessonCount); }
        }
    }
}
