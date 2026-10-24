using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class QuizSummary
    {
        public int QuizID { get; set; }
        public string Title { get; set; }
        public string QuizType { get; set; }
        public string Topic { get; set; }
        public int TimeLimitMin { get; set; }
        public int QuestionCount { get; set; }
    }

    public class QuizQuestion
    {
        public int QuestionID { get; set; }
        public string QuestionText { get; set; }
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }
        public string CorrectOption { get; set; }
        public int Marks { get; set; }
    }

    public class QuizResultSummary
    {
        public int Score { get; set; }
        public int TotalMarks { get; set; }
        public int CorrectCount { get; set; }
        public int IncorrectCount { get; set; }
        public int TimeTakenSec { get; set; }
        public int Percentage { get { return TotalMarks == 0 ? 0 : (int)Math.Round(Score * 100.0 / TotalMarks); } }
        public string PerformanceMessage
        {
            get
            {
                if (Percentage >= 90) return "Outstanding — you've mastered this topic!";
                if (Percentage >= 70) return "Great job — solid understanding.";
                if (Percentage >= 50) return "Good effort — review the topics you missed.";
                return "Keep practicing — revisit the lesson before trying again.";
            }
        }
    }

    /// <summary>Business rules for listing quizzes, serving questions, and grading attempts.</summary>
    public static class QuizBLL
    {
        public static List<QuizSummary> GetAllActive()
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT Q.QuizID, Q.Title, Q.QuizType, Q.Topic, Q.TimeLimitMin, COUNT(QN.QuestionID) AS QCount " +
                "FROM Quiz Q LEFT JOIN Question QN ON QN.QuizID = Q.QuizID " +
                "WHERE Q.IsActive = 1 " +
                "GROUP BY Q.QuizID, Q.Title, Q.QuizType, Q.Topic, Q.TimeLimitMin " +
                "ORDER BY Q.QuizID");

            var list = new List<QuizSummary>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new QuizSummary
                {
                    QuizID = Convert.ToInt32(row["QuizID"]),
                    Title = row["Title"].ToString(),
                    QuizType = row["QuizType"].ToString(),
                    Topic = row["Topic"].ToString(),
                    TimeLimitMin = Convert.ToInt32(row["TimeLimitMin"]),
                    QuestionCount = Convert.ToInt32(row["QCount"])
                });
            }
            return list;
        }

        public static string GetQuizTitle(int quizId)
        {
            object result = DBHelper.ExecuteScalar("SELECT Title FROM Quiz WHERE QuizID = @Id", DBHelper.Param("@Id", quizId));
            return result == null ? string.Empty : result.ToString();
        }

        public static List<QuizQuestion> GetQuestions(int quizId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Marks " +
                "FROM Question WHERE QuizID = @QuizId ORDER BY QuestionID",
                DBHelper.Param("@QuizId", quizId));

            var list = new List<QuizQuestion>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new QuizQuestion
                {
                    QuestionID = Convert.ToInt32(row["QuestionID"]),
                    QuestionText = row["QuestionText"].ToString(),
                    OptionA = row["OptionA"].ToString(),
                    OptionB = row["OptionB"].ToString(),
                    OptionC = row["OptionC"].ToString(),
                    OptionD = row["OptionD"].ToString(),
                    CorrectOption = row["CorrectOption"].ToString(),
                    Marks = Convert.ToInt32(row["Marks"])
                });
            }
            return list;
        }

        public static QuizResultSummary Submit(int studentId, int quizId, Dictionary<int, string> answers, int timeTakenSec)
        {
            List<QuizQuestion> questions = GetQuestions(quizId);
            var summary = new QuizResultSummary { TimeTakenSec = timeTakenSec };

            foreach (QuizQuestion q in questions)
            {
                summary.TotalMarks += q.Marks;
                string selected;
                bool answered = answers.TryGetValue(q.QuestionID, out selected);

                if (answered && string.Equals(selected, q.CorrectOption, StringComparison.OrdinalIgnoreCase))
                {
                    summary.Score += q.Marks;
                    summary.CorrectCount++;
                }
                else
                {
                    summary.IncorrectCount++;
                }
            }

            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Result (StudentID, QuizID, Score, TotalMarks, CorrectCount, IncorrectCount, TimeTakenSec) " +
                "VALUES (@Sid, @Qid, @Score, @Total, @Correct, @Incorrect, @Time)",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Qid", quizId),
                DBHelper.Param("@Score", summary.Score), DBHelper.Param("@Total", summary.TotalMarks),
                DBHelper.Param("@Correct", summary.CorrectCount), DBHelper.Param("@Incorrect", summary.IncorrectCount),
                DBHelper.Param("@Time", timeTakenSec));

            int xp = 20;
            if (summary.TotalMarks > 0 && summary.Score == summary.TotalMarks) xp += 10;
            StudentBLL.AddXP(studentId, xp);
            AchievementBLL.EvaluateAndGrant(studentId);

            return summary;
        }

        public static DataTable GetHistory(int studentId)
        {
            return DBHelper.ExecuteQuery(
                "SELECT R.ResultID, Q.Title, R.Score, R.TotalMarks, R.AttemptedOn " +
                "FROM Result R JOIN Quiz Q ON Q.QuizID = R.QuizID " +
                "WHERE R.StudentID = @Id ORDER BY R.AttemptedOn DESC",
                DBHelper.Param("@Id", studentId));
        }
    }
}
