using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class ChallengeItem
    {
        public int ChallengeID { get; set; }
        public string ChallengeType { get; set; }
        public string Difficulty { get; set; }
        public string Question { get; set; }
        public string CodeSnippet { get; set; }
        public string Hint1 { get; set; }
        public string Hint2 { get; set; }
        public string Solution { get; set; }
        public int XPReward { get; set; }
        public string Category { get; set; }
        public string PreventionTip { get; set; }
    }

    /// <summary>Business rules for the Debug Lab: serving challenges and recording self-graded attempts.</summary>
    public static class ChallengeBLL
    {
        public static List<ChallengeItem> GetAll()
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT ChallengeID, ChallengeType, Difficulty, Question, CodeSnippet, Hint1, Hint2, Solution, XPReward, Category, PreventionTip " +
                "FROM Challenge ORDER BY " +
                "CASE Difficulty WHEN 'Easy' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END, ChallengeID");

            var list = new List<ChallengeItem>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new ChallengeItem
                {
                    ChallengeID = Convert.ToInt32(row["ChallengeID"]),
                    ChallengeType = row["ChallengeType"].ToString(),
                    Difficulty = row["Difficulty"].ToString(),
                    Question = row["Question"].ToString(),
                    CodeSnippet = row["CodeSnippet"].ToString(),
                    Hint1 = row["Hint1"].ToString(),
                    Hint2 = row["Hint2"].ToString(),
                    Solution = row["Solution"].ToString(),
                    XPReward = Convert.ToInt32(row["XPReward"]),
                    Category = row["Category"] == DBNull.Value ? string.Empty : row["Category"].ToString(),
                    PreventionTip = row["PreventionTip"] == DBNull.Value ? string.Empty : row["PreventionTip"].ToString()
                });
            }
            return list;
        }

        public static ChallengeItem GetById(int id)
        {
            return GetAll().Find(c => c.ChallengeID == id);
        }

        public static int RecordAttempt(int studentId, int challengeId, bool isCorrect, int hintsUsed)
        {
            ChallengeItem challenge = GetById(challengeId);
            int xpEarned = 0;

            if (isCorrect && challenge != null)
            {
                xpEarned = Math.Max(5, challenge.XPReward - (hintsUsed * 5));
                StudentBLL.AddXP(studentId, xpEarned);
                AchievementBLL.EvaluateAndGrant(studentId);
            }

            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO ChallengeAttempt (StudentID, ChallengeID, IsCorrect, HintsUsed, XPEarned) " +
                "VALUES (@Sid, @Cid, @Correct, @Hints, @Xp)",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Cid", challengeId),
                DBHelper.Param("@Correct", isCorrect), DBHelper.Param("@Hints", hintsUsed),
                DBHelper.Param("@Xp", xpEarned));

            return xpEarned;
        }
    }
}
