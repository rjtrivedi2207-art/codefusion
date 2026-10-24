using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class AchievementItem
    {
        public int AchievementID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string IconClass { get; set; }
        public bool IsUnlocked { get; set; }
        public DateTime? EarnedOn { get; set; }
    }

    public static class AchievementBLL
    {
        public static List<AchievementItem> GetForStudent(int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT A.AchievementID, A.Title, A.Description, A.IconClass, SA.EarnedOn " +
                "FROM Achievement A " +
                "LEFT JOIN StudentAchievement SA ON SA.AchievementID = A.AchievementID AND SA.StudentID = @Sid " +
                "ORDER BY A.AchievementID",
                DBHelper.Param("@Sid", studentId));

            var list = new List<AchievementItem>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new AchievementItem
                {
                    AchievementID = Convert.ToInt32(row["AchievementID"]),
                    Title = row["Title"].ToString(),
                    Description = row["Description"].ToString(),
                    IconClass = row["IconClass"].ToString(),
                    IsUnlocked = row["EarnedOn"] != DBNull.Value,
                    EarnedOn = row["EarnedOn"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["EarnedOn"])
                });
            }
            return list;
        }

        public static void Grant(int studentId, string achievementTitle)
        {
            object idObj = DBHelper.ExecuteScalar("SELECT AchievementID FROM Achievement WHERE Title = @Title", DBHelper.Param("@Title", achievementTitle));
            if (idObj == null || idObj == DBNull.Value) return;
            int achievementId = Convert.ToInt32(idObj);

            bool already = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM StudentAchievement WHERE StudentID = @Sid AND AchievementID = @Aid",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Aid", achievementId))) > 0;
            if (already) return;

            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO StudentAchievement (StudentID, AchievementID) VALUES (@Sid, @Aid)",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Aid", achievementId));
        }

        /// <summary>Checks all rule-based badges for a student and grants any newly-earned ones.
        /// Call this after any XP-earning action (lesson complete, challenge solved, quiz submitted).</summary>
        public static void EvaluateAndGrant(int studentId)
        {
            int completedLessons = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM LessonProgress WHERE StudentID = @Id AND IsCompleted = 1", DBHelper.Param("@Id", studentId)));
            if (completedLessons >= 1) Grant(studentId, "First Step");
            if (completedLessons >= 6) Grant(studentId, "ASP.NET Explorer");
            if (completedLessons >= 12) Grant(studentId, "ASP.NET Master");

            int solvedChallenges = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM ChallengeAttempt WHERE StudentID = @Id AND IsCorrect = 1", DBHelper.Param("@Id", studentId)));
            if (solvedChallenges >= 5) Grant(studentId, "Bug Hunter");

            int quizAttempts = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Result WHERE StudentID = @Id", DBHelper.Param("@Id", studentId)));
            if (quizAttempts >= 10) Grant(studentId, "Quiz Warrior");

            bool hasPerfect = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Result WHERE StudentID = @Id AND Score = TotalMarks AND TotalMarks > 0", DBHelper.Param("@Id", studentId))) > 0;
            if (hasPerfect) Grant(studentId, "Perfect Score");
        }
    }
}
