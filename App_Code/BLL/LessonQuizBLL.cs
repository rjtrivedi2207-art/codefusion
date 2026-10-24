using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class LessonQuizQuestion
    {
        public int LessonQuizQuestionID { get; set; }
        public int LessonID { get; set; }
        public string QuestionText { get; set; }
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }
        public string CorrectOption { get; set; }
        public int DisplayOrder { get; set; }
    }

    /// <summary>
    /// Business rules for the lightweight "3-5 question" mini-quiz shown directly on a
    /// lesson page. This is intentionally separate from the full Quiz Arena (Quiz/Question/
    /// Result tables) — it's a quick in-page comprehension check, not a timed, tracked attempt.
    /// </summary>
    public static class LessonQuizBLL
    {
        public static List<LessonQuizQuestion> GetForLesson(int lessonId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT LessonQuizQuestionID, LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder " +
                "FROM LessonQuizQuestion WHERE LessonID = @Id ORDER BY DisplayOrder",
                DBHelper.Param("@Id", lessonId));

            var list = new List<LessonQuizQuestion>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new LessonQuizQuestion
                {
                    LessonQuizQuestionID = Convert.ToInt32(row["LessonQuizQuestionID"]),
                    LessonID = Convert.ToInt32(row["LessonID"]),
                    QuestionText = row["QuestionText"].ToString(),
                    OptionA = row["OptionA"].ToString(),
                    OptionB = row["OptionB"].ToString(),
                    OptionC = row["OptionC"].ToString(),
                    OptionD = row["OptionD"].ToString(),
                    CorrectOption = row["CorrectOption"].ToString(),
                    DisplayOrder = Convert.ToInt32(row["DisplayOrder"])
                });
            }
            return list;
        }

        /// <summary>Grades answers (QuestionID -> selected letter) against the correct options.</summary>
        public static int Grade(List<LessonQuizQuestion> questions, Dictionary<int, string> answers)
        {
            int correct = 0;
            foreach (var q in questions)
            {
                string selected;
                if (answers.TryGetValue(q.LessonQuizQuestionID, out selected) &&
                    string.Equals(selected, q.CorrectOption, StringComparison.OrdinalIgnoreCase))
                {
                    correct++;
                }
            }
            return correct;
        }

        // ---------------- Admin management ----------------

        public static void AddQuestion(int lessonId, string text, string a, string b, string c, string d, string correct, int displayOrder)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) " +
                "VALUES (@Lid, @Text, @A, @B, @C, @D, @Correct, @Order)",
                DBHelper.Param("@Lid", lessonId), DBHelper.Param("@Text", text), DBHelper.Param("@A", a), DBHelper.Param("@B", b),
                DBHelper.Param("@C", c), DBHelper.Param("@D", d), DBHelper.Param("@Correct", correct), DBHelper.Param("@Order", displayOrder));
        }

        public static void DeleteQuestion(int questionId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM LessonQuizQuestion WHERE LessonQuizQuestionID = @Id", DBHelper.Param("@Id", questionId));
        }
    }
}
