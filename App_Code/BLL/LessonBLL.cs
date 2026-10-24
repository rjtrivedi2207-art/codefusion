using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;
using CodeFusion.Entities;

namespace CodeFusion.BLL
{
    /// <summary>Business rules for Lessons: student-facing retrieval/completion, and admin CRUD.</summary>
    public static class LessonBLL
    {
        private const int XpPerLesson = 10;

        private const string SelectColumns =
            "SELECT L.LessonID, L.ModuleID, L.Title, L.ShortDescription, L.LearningObjectives, L.Explanation, " +
            "       L.Syntax, L.CodeExample, L.CodeExplanation, L.ExpectedOutput, L.RealWorldUse, L.CommonMistakes, " +
            "       L.Troubleshooting, L.KeyPoints, L.PracticeTask, L.CodeLanguage, L.DisplayOrder, L.IsPublished, L.CreatedDate, " +
            "       M.ModuleTitle, M.ModuleOrder ";

        private static Lesson MapRow(DataRow row, bool includeCompletion)
        {
            var lesson = new Lesson
            {
                LessonID = Convert.ToInt32(row["LessonID"]),
                ModuleID = Convert.ToInt32(row["ModuleID"]),
                Title = row["Title"].ToString(),
                ShortDescription = row["ShortDescription"].ToString(),
                LearningObjectives = row["LearningObjectives"].ToString(),
                Explanation = row["Explanation"].ToString(),
                Syntax = row["Syntax"].ToString(),
                CodeExample = row["CodeExample"].ToString(),
                CodeExplanation = row["CodeExplanation"].ToString(),
                ExpectedOutput = row["ExpectedOutput"].ToString(),
                RealWorldUse = row["RealWorldUse"].ToString(),
                CommonMistakes = row["CommonMistakes"].ToString(),
                Troubleshooting = row["Troubleshooting"].ToString(),
                KeyPoints = row["KeyPoints"].ToString(),
                PracticeTask = row["PracticeTask"].ToString(),
                CodeLanguage = row["CodeLanguage"].ToString(),
                DisplayOrder = Convert.ToInt32(row["DisplayOrder"]),
                IsPublished = Convert.ToBoolean(row["IsPublished"]),
                CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                ModuleTitle = row["ModuleTitle"].ToString(),
                ModuleOrder = Convert.ToInt32(row["ModuleOrder"])
            };
            if (includeCompletion)
                lesson.IsCompleted = Convert.ToInt32(row["IsCompleted"]) == 1;
            return lesson;
        }

        /// <summary>Every published lesson across every module, flattened in module/lesson order.
        /// Kept for pages that need an all-lessons view (Dashboard snapshot, Progress, Notes picker).</summary>
        public static List<Lesson> GetRoadmap(int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                SelectColumns +
                ", CASE WHEN LP.IsCompleted = 1 THEN 1 ELSE 0 END AS IsCompleted " +
                "FROM Lesson L JOIN Module M ON M.ModuleID = L.ModuleID " +
                "LEFT JOIN LessonProgress LP ON LP.LessonID = L.LessonID AND LP.StudentID = @StudentID " +
                "WHERE L.IsPublished = 1 AND M.IsActive = 1 " +
                "ORDER BY M.ModuleOrder, L.DisplayOrder",
                DBHelper.Param("@StudentID", studentId));

            var list = new List<Lesson>();
            foreach (DataRow row in dt.Rows) list.Add(MapRow(row, true));
            return list;
        }

        /// <summary>Published lessons within a single module, for the module detail page.</summary>
        public static List<Lesson> GetLessonsForModule(int moduleId, int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                SelectColumns +
                ", CASE WHEN LP.IsCompleted = 1 THEN 1 ELSE 0 END AS IsCompleted " +
                "FROM Lesson L JOIN Module M ON M.ModuleID = L.ModuleID " +
                "LEFT JOIN LessonProgress LP ON LP.LessonID = L.LessonID AND LP.StudentID = @StudentID " +
                "WHERE L.IsPublished = 1 AND L.ModuleID = @ModuleID " +
                "ORDER BY L.DisplayOrder",
                DBHelper.Param("@StudentID", studentId), DBHelper.Param("@ModuleID", moduleId));

            var list = new List<Lesson>();
            foreach (DataRow row in dt.Rows) list.Add(MapRow(row, true));
            return list;
        }

        public static Lesson GetById(int lessonId, int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                SelectColumns +
                ", CASE WHEN LP.IsCompleted = 1 THEN 1 ELSE 0 END AS IsCompleted " +
                "FROM Lesson L JOIN Module M ON M.ModuleID = L.ModuleID " +
                "LEFT JOIN LessonProgress LP ON LP.LessonID = L.LessonID AND LP.StudentID = @StudentID " +
                "WHERE L.LessonID = @LessonID",
                DBHelper.Param("@StudentID", studentId), DBHelper.Param("@LessonID", lessonId));

            return dt.Rows.Count == 0 ? null : MapRow(dt.Rows[0], true);
        }

        public static void MarkComplete(int studentId, int lessonId)
        {
            bool alreadyCompleted = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM LessonProgress WHERE StudentID = @Sid AND LessonID = @Lid AND IsCompleted = 1",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Lid", lessonId))) > 0;

            if (alreadyCompleted) return;

            bool rowExists = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM LessonProgress WHERE StudentID = @Sid AND LessonID = @Lid",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Lid", lessonId))) > 0;

            if (rowExists)
            {
                DBHelper.ExecuteNonQuery(
                    "UPDATE LessonProgress SET IsCompleted = 1, CompletedOn = @Now WHERE StudentID = @Sid AND LessonID = @Lid",
                    DBHelper.Param("@Now", DateTime.Now), DBHelper.Param("@Sid", studentId), DBHelper.Param("@Lid", lessonId));
            }
            else
            {
                DBHelper.ExecuteInsertReturnId(
                    "INSERT INTO LessonProgress (StudentID, LessonID, IsCompleted, CompletedOn) VALUES (@Sid, @Lid, 1, @Now)",
                    DBHelper.Param("@Sid", studentId), DBHelper.Param("@Lid", lessonId), DBHelper.Param("@Now", DateTime.Now));
            }

            StudentBLL.AddXP(studentId, XpPerLesson);
            AchievementBLL.EvaluateAndGrant(studentId);
        }

        // ---------------- Admin management ----------------

        public static DataTable GetLessonsForModuleRaw(int moduleId)
        {
            return DBHelper.ExecuteQuery(
                "SELECT LessonID, Title, DisplayOrder, IsPublished FROM Lesson WHERE ModuleID = @Id ORDER BY DisplayOrder",
                DBHelper.Param("@Id", moduleId));
        }

        public static void SaveLesson(int lessonId, int moduleId, string title, string shortDescription, string learningObjectives,
            string explanation, string syntax, string codeExample, string codeExplanation, string expectedOutput,
            string realWorldUse, string commonMistakes, string troubleshooting, string keyPoints, string practiceTask,
            string codeLanguage, int displayOrder, bool isPublished)
        {
            if (lessonId == 0)
            {
                DBHelper.ExecuteInsertReturnId(
                    "INSERT INTO Lesson (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, " +
                    "CodeExplanation, ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, KeyPoints, PracticeTask, " +
                    "CodeLanguage, DisplayOrder, IsPublished) " +
                    "VALUES (@ModuleID, @Title, @ShortDesc, @Objectives, @Expl, @Syntax, @Code, @CodeExpl, @Output, @RealWorld, " +
                    "@Mistakes, @Troubleshoot, @KeyPoints, @Task, @Lang, @Order, @Pub)",
                    DBHelper.Param("@ModuleID", moduleId), DBHelper.Param("@Title", title), DBHelper.Param("@ShortDesc", shortDescription),
                    DBHelper.Param("@Objectives", learningObjectives), DBHelper.Param("@Expl", explanation), DBHelper.Param("@Syntax", syntax),
                    DBHelper.Param("@Code", codeExample), DBHelper.Param("@CodeExpl", codeExplanation), DBHelper.Param("@Output", expectedOutput),
                    DBHelper.Param("@RealWorld", realWorldUse), DBHelper.Param("@Mistakes", commonMistakes),
                    DBHelper.Param("@Troubleshoot", troubleshooting), DBHelper.Param("@KeyPoints", keyPoints),
                    DBHelper.Param("@Task", practiceTask), DBHelper.Param("@Lang", codeLanguage),
                    DBHelper.Param("@Order", displayOrder), DBHelper.Param("@Pub", isPublished));
            }
            else
            {
                DBHelper.ExecuteNonQuery(
                    "UPDATE Lesson SET ModuleID=@ModuleID, Title=@Title, ShortDescription=@ShortDesc, LearningObjectives=@Objectives, " +
                    "Explanation=@Expl, Syntax=@Syntax, CodeExample=@Code, CodeExplanation=@CodeExpl, ExpectedOutput=@Output, " +
                    "RealWorldUse=@RealWorld, CommonMistakes=@Mistakes, Troubleshooting=@Troubleshoot, KeyPoints=@KeyPoints, " +
                    "PracticeTask=@Task, CodeLanguage=@Lang, DisplayOrder=@Order, IsPublished=@Pub WHERE LessonID=@Id",
                    DBHelper.Param("@ModuleID", moduleId), DBHelper.Param("@Title", title), DBHelper.Param("@ShortDesc", shortDescription),
                    DBHelper.Param("@Objectives", learningObjectives), DBHelper.Param("@Expl", explanation), DBHelper.Param("@Syntax", syntax),
                    DBHelper.Param("@Code", codeExample), DBHelper.Param("@CodeExpl", codeExplanation), DBHelper.Param("@Output", expectedOutput),
                    DBHelper.Param("@RealWorld", realWorldUse), DBHelper.Param("@Mistakes", commonMistakes),
                    DBHelper.Param("@Troubleshoot", troubleshooting), DBHelper.Param("@KeyPoints", keyPoints),
                    DBHelper.Param("@Task", practiceTask), DBHelper.Param("@Lang", codeLanguage),
                    DBHelper.Param("@Order", displayOrder), DBHelper.Param("@Pub", isPublished), DBHelper.Param("@Id", lessonId));
            }
        }

        public static void DeleteLesson(int lessonId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM LessonQuizQuestion WHERE LessonID = @Id", DBHelper.Param("@Id", lessonId));
            DBHelper.ExecuteNonQuery("DELETE FROM StudentNote WHERE LessonID = @Id", DBHelper.Param("@Id", lessonId));
            DBHelper.ExecuteNonQuery("DELETE FROM LessonProgress WHERE LessonID = @Id", DBHelper.Param("@Id", lessonId));
            DBHelper.ExecuteNonQuery("DELETE FROM Lesson WHERE LessonID = @Id", DBHelper.Param("@Id", lessonId));
        }
    }
}
