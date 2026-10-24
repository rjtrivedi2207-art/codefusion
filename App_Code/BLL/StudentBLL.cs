using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;
using CodeFusion.Entities;

namespace CodeFusion.BLL
{
    /// <summary>Business rules for student XP, levels, streaks and dashboard summary data.</summary>
    public static class StudentBLL
    {
        public static int CalculateLevel(int xp)
        {
            return Math.Max(1, (xp / 100) + 1);
        }

        public static int XpIntoCurrentLevel(int xp)
        {
            return xp % 100;
        }

        public static void AddXP(int studentId, int amount)
        {
            DataTable dt = DBHelper.ExecuteQuery("SELECT XP FROM Student WHERE StudentID = @Id", DBHelper.Param("@Id", studentId));
            if (dt.Rows.Count == 0) return;

            int currentXp = Convert.ToInt32(dt.Rows[0]["XP"]);
            int newXp = currentXp + amount;
            int newLevel = CalculateLevel(newXp);

            DBHelper.ExecuteNonQuery(
                "UPDATE Student SET XP = @XP, Level = @Level WHERE StudentID = @Id",
                DBHelper.Param("@XP", newXp),
                DBHelper.Param("@Level", newLevel),
                DBHelper.Param("@Id", studentId));
        }

        public static void TouchStreak(int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT LastActiveDate, StreakDays FROM Student WHERE StudentID = @Id",
                DBHelper.Param("@Id", studentId));
            if (dt.Rows.Count == 0) return;

            DateTime today = DateTime.Today;
            DateTime? lastActive = dt.Rows[0]["LastActiveDate"] == DBNull.Value
                ? (DateTime?)null
                : Convert.ToDateTime(dt.Rows[0]["LastActiveDate"]);
            int streak = Convert.ToInt32(dt.Rows[0]["StreakDays"]);

            if (lastActive == today) return;

            streak = (lastActive.HasValue && lastActive.Value == today.AddDays(-1)) ? streak + 1 : 1;

            DBHelper.ExecuteNonQuery(
                "UPDATE Student SET StreakDays = @Streak, LastActiveDate = @Today WHERE StudentID = @Id",
                DBHelper.Param("@Streak", streak),
                DBHelper.Param("@Today", today),
                DBHelper.Param("@Id", studentId));
        }

        public static Student GetById(int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT StudentID, FullName, Email, XP, Level, StreakDays, LastActiveDate, IsActive, CreatedOn " +
                "FROM Student WHERE StudentID = @Id",
                DBHelper.Param("@Id", studentId));
            if (dt.Rows.Count == 0) return null;

            DataRow row = dt.Rows[0];
            return new Student
            {
                StudentID = Convert.ToInt32(row["StudentID"]),
                FullName = row["FullName"].ToString(),
                Email = row["Email"].ToString(),
                XP = Convert.ToInt32(row["XP"]),
                Level = Convert.ToInt32(row["Level"]),
                StreakDays = Convert.ToInt32(row["StreakDays"]),
                LastActiveDate = row["LastActiveDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["LastActiveDate"]),
                IsActive = Convert.ToBoolean(row["IsActive"]),
                CreatedOn = Convert.ToDateTime(row["CreatedOn"])
            };
        }

        public static DashboardStats GetDashboardStats(int studentId)
        {
            var stats = new DashboardStats();

            int totalLessons = Convert.ToInt32(DBHelper.ExecuteScalar("SELECT COUNT(1) FROM Lesson WHERE IsPublished = 1"));
            int completedLessons = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM LessonProgress WHERE StudentID = @Id AND IsCompleted = 1",
                DBHelper.Param("@Id", studentId)));

            stats.TotalLessons = totalLessons;
            stats.CompletedLessons = completedLessons;
            stats.CompletionPercent = totalLessons == 0 ? 0 : (int)Math.Round(completedLessons * 100.0 / totalLessons);

            stats.CompletedChallenges = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM ChallengeAttempt WHERE StudentID = @Id AND IsCorrect = 1",
                DBHelper.Param("@Id", studentId)));

            object avgObj = DBHelper.ExecuteScalar(
                "SELECT AVG(CAST(Score AS FLOAT) / NULLIF(TotalMarks,0) * 100) FROM Result WHERE StudentID = @Id",
                DBHelper.Param("@Id", studentId));
            stats.QuizAveragePercent = (avgObj == null || avgObj == DBNull.Value) ? 0 : (int)Math.Round(Convert.ToDouble(avgObj));

            stats.EarnedBadges = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM StudentAchievement WHERE StudentID = @Id",
                DBHelper.Param("@Id", studentId)));

            return stats;
        }
    }

    public static class StudentActivityBLL
    {
        public static List<ActivityItem> GetRecent(int studentId, int limit)
        {
            var items = new List<ActivityItem>();

            DataTable lessons = DBHelper.ExecuteQuery(
                "SELECT TOP (@Limit) L.Title, LP.CompletedOn " +
                "FROM LessonProgress LP JOIN Lesson L ON L.LessonID = LP.LessonID " +
                "WHERE LP.StudentID = @Id AND LP.IsCompleted = 1 ORDER BY LP.CompletedOn DESC",
                DBHelper.Param("@Limit", limit), DBHelper.Param("@Id", studentId));
            foreach (DataRow row in lessons.Rows)
                items.Add(new ActivityItem { IconClass = "fa-solid fa-book", Description = "Completed lesson: " + row["Title"], When = Convert.ToDateTime(row["CompletedOn"]) });

            DataTable challenges = DBHelper.ExecuteQuery(
                "SELECT TOP (@Limit) C.ChallengeType, CA.AttemptedOn, CA.IsCorrect " +
                "FROM ChallengeAttempt CA JOIN Challenge C ON C.ChallengeID = CA.ChallengeID " +
                "WHERE CA.StudentID = @Id ORDER BY CA.AttemptedOn DESC",
                DBHelper.Param("@Limit", limit), DBHelper.Param("@Id", studentId));
            foreach (DataRow row in challenges.Rows)
                items.Add(new ActivityItem
                {
                    IconClass = "fa-solid fa-bug",
                    Description = (Convert.ToBoolean(row["IsCorrect"]) ? "Solved" : "Attempted") + " a " + row["ChallengeType"] + " challenge",
                    When = Convert.ToDateTime(row["AttemptedOn"])
                });

            DataTable quizzes = DBHelper.ExecuteQuery(
                "SELECT TOP (@Limit) Q.Title, R.Score, R.TotalMarks, R.AttemptedOn " +
                "FROM Result R JOIN Quiz Q ON Q.QuizID = R.QuizID " +
                "WHERE R.StudentID = @Id ORDER BY R.AttemptedOn DESC",
                DBHelper.Param("@Limit", limit), DBHelper.Param("@Id", studentId));
            foreach (DataRow row in quizzes.Rows)
                items.Add(new ActivityItem { IconClass = "fa-solid fa-swords", Description = "Scored " + row["Score"] + "/" + row["TotalMarks"] + " on " + row["Title"], When = Convert.ToDateTime(row["AttemptedOn"]) });

            items.Sort((a, b) => b.When.CompareTo(a.When));
            return items.GetRange(0, Math.Min(limit, items.Count));
        }
    }

    public class ActivityItem
    {
        public string IconClass { get; set; }
        public string Description { get; set; }
        public DateTime When { get; set; }
        public string WhenText { get { return TimeAgo(When); } }

        private static string TimeAgo(DateTime when)
        {
            TimeSpan span = DateTime.Now - when;
            if (span.TotalMinutes < 1) return "just now";
            if (span.TotalHours < 1) return (int)span.TotalMinutes + "m ago";
            if (span.TotalDays < 1) return (int)span.TotalHours + "h ago";
            return (int)span.TotalDays + "d ago";
        }
    }

    public class DashboardStats
    {
        public int TotalLessons { get; set; }
        public int CompletedLessons { get; set; }
        public int CompletionPercent { get; set; }
        public int CompletedChallenges { get; set; }
        public int QuizAveragePercent { get; set; }
        public int EarnedBadges { get; set; }
    }
}
