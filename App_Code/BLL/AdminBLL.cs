using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class AdminDashboardStats
    {
        public int TotalStudents { get; set; }
        public int TotalLessons { get; set; }
        public int TotalMaterials { get; set; }
        public int TotalQuizzes { get; set; }
        public int TotalQuestions { get; set; }
        public int TotalChallenges { get; set; }
        public int TotalAttempts { get; set; }
        public int TotalEmployees { get; set; }
        public int TotalModules { get; set; }
    }

    /// <summary>Business rules for the Admin panel: dashboard counts and student management.</summary>
    public static class AdminBLL
    {
        public static AdminDashboardStats GetDashboardStats()
        {
            return new AdminDashboardStats
            {
                TotalStudents = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Student")),
                TotalLessons = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Lesson")),
                TotalMaterials = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Material")),
                TotalQuizzes = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Quiz")),
                TotalQuestions = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Question")),
                TotalChallenges = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Challenge")),
                TotalAttempts = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Result")),
                TotalEmployees = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Employee")),
                TotalModules = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Module"))
            };
        }

        // ---------------- Students ----------------

        public static DataTable SearchStudents(string search)
        {
            if (string.IsNullOrWhiteSpace(search))
            {
                return DBHelper.ExecuteQuery(
                    "SELECT StudentID, FullName, Email, XP, Level, IsActive, CreatedOn FROM Student ORDER BY StudentID DESC");
            }

            return DBHelper.ExecuteQuery(
                "SELECT StudentID, FullName, Email, XP, Level, IsActive, CreatedOn FROM Student " +
                "WHERE FullName LIKE @Search OR Email LIKE @Search ORDER BY StudentID DESC",
                DBHelper.Param("@Search", "%" + search + "%"));
        }

        public static void SetStudentActive(int studentId, bool isActive)
        {
            DBHelper.ExecuteNonQuery(
                "UPDATE Student SET IsActive = @Active WHERE StudentID = @Id",
                DBHelper.Param("@Active", isActive), DBHelper.Param("@Id", studentId));
        }

        // Lesson management now lives in LessonBLL (GetLessonsForModuleRaw/SaveLesson/DeleteLesson),
        // since lessons are scoped to a Module in the new schema. Module management lives in ModuleBLL.

        // ---------------- Quizzes & Questions ----------------

        public static DataTable GetAllQuizzesRaw()
        {
            return DBHelper.ExecuteQuery(
                "SELECT Q.QuizID, Q.Title, Q.QuizType, Q.Topic, Q.TimeLimitMin, Q.IsActive, COUNT(QN.QuestionID) AS QCount " +
                "FROM Quiz Q LEFT JOIN Question QN ON QN.QuizID = Q.QuizID " +
                "GROUP BY Q.QuizID, Q.Title, Q.QuizType, Q.Topic, Q.TimeLimitMin, Q.IsActive ORDER BY Q.QuizID DESC");
        }

        public static int CreateQuiz(string title, string quizType, string topic, int timeLimitMin)
        {
            return DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Quiz (Title, QuizType, Topic, TimeLimitMin, TotalMarks, IsActive) VALUES (@Title, @Type, @Topic, @Time, 0, 1)",
                DBHelper.Param("@Title", title), DBHelper.Param("@Type", quizType), DBHelper.Param("@Topic", topic), DBHelper.Param("@Time", timeLimitMin));
        }

        public static void DeleteQuiz(int quizId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM Result WHERE QuizID = @Id", DBHelper.Param("@Id", quizId));
            DBHelper.ExecuteNonQuery("DELETE FROM Question WHERE QuizID = @Id", DBHelper.Param("@Id", quizId));
            DBHelper.ExecuteNonQuery("DELETE FROM Quiz WHERE QuizID = @Id", DBHelper.Param("@Id", quizId));
        }

        public static void ToggleQuizActive(int quizId, bool isActive)
        {
            DBHelper.ExecuteNonQuery("UPDATE Quiz SET IsActive = @Active WHERE QuizID = @Id",
                DBHelper.Param("@Active", isActive), DBHelper.Param("@Id", quizId));
        }

        public static void AddQuestion(int quizId, string text, string a, string b, string c, string d, string correct, int marks)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, Marks) " +
                "VALUES (@Qid, @Text, @A, @B, @C, @D, @Correct, @Marks)",
                DBHelper.Param("@Qid", quizId), DBHelper.Param("@Text", text), DBHelper.Param("@A", a), DBHelper.Param("@B", b),
                DBHelper.Param("@C", c), DBHelper.Param("@D", d), DBHelper.Param("@Correct", correct), DBHelper.Param("@Marks", marks));
        }

        public static void DeleteQuestion(int questionId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM Question WHERE QuestionID = @Id", DBHelper.Param("@Id", questionId));
        }

        // ---------------- Challenges ----------------

        public static void DeleteChallenge(int challengeId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM ChallengeAttempt WHERE ChallengeID = @Id", DBHelper.Param("@Id", challengeId));
            DBHelper.ExecuteNonQuery("DELETE FROM Challenge WHERE ChallengeID = @Id", DBHelper.Param("@Id", challengeId));
        }

        public static void AddChallenge(string type, string category, string difficulty, string question, string code, string answer,
            string hint1, string hint2, string solution, string preventionTip, int xpReward)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Challenge (ChallengeType, Category, Difficulty, Question, CodeSnippet, Answer, Hint1, Hint2, Solution, PreventionTip, XPReward) " +
                "VALUES (@Type, @Category, @Diff, @Q, @Code, @Answer, @H1, @H2, @Sol, @Prevent, @Xp)",
                DBHelper.Param("@Type", type), DBHelper.Param("@Category", category), DBHelper.Param("@Diff", difficulty), DBHelper.Param("@Q", question),
                DBHelper.Param("@Code", code), DBHelper.Param("@Answer", answer), DBHelper.Param("@H1", hint1),
                DBHelper.Param("@H2", hint2), DBHelper.Param("@Sol", solution), DBHelper.Param("@Prevent", preventionTip), DBHelper.Param("@Xp", xpReward));
        }

        // ---------------- Results ----------------

        public static DataTable GetAllResults()
        {
            return DBHelper.ExecuteQuery(
                "SELECT R.ResultID, S.FullName, Q.Title, R.Score, R.TotalMarks, R.AttemptedOn " +
                "FROM Result R JOIN Student S ON S.StudentID = R.StudentID JOIN Quiz Q ON Q.QuizID = R.QuizID " +
                "ORDER BY R.AttemptedOn DESC");
        }
    }
}
