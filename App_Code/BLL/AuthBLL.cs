using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using CodeFusion.DAL;
using CodeFusion.Entities;

namespace CodeFusion.BLL
{
    /// <summary>
    /// Business rules for registration, login and session-based authentication.
    /// The Presentation layer should only ever call into this class — it
    /// never talks to DBHelper directly.
    /// </summary>
    public static class AuthBLL
    {
        private const string SessionStudentId = "StudentID";
        private const string SessionStudentName = "StudentName";
        private const string SessionAdminId = "AdminID";
        private const string SessionAdminName = "AdminName";

        // ---------------- Student ----------------

        public static bool EmailExists(string email)
        {
            object result = DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Student WHERE Email = @Email",
                DBHelper.Param("@Email", email));
            return Convert.ToInt32(result) > 0;
        }

        public static string RegisterStudent(string fullName, string email, string password)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "Full name is required.";
            if (string.IsNullOrWhiteSpace(email)) return "Email is required.";
            if (string.IsNullOrWhiteSpace(password) || password.Length < 6) return "Password must be at least 6 characters.";
            if (EmailExists(email)) return "An account with this email already exists.";

            string hash = PasswordHelper.Hash(password);

            try
            {
                DBHelper.ExecuteInsertReturnId(
                    "INSERT INTO Student (FullName, Email, PasswordHash, XP, Level, StreakDays, LastActiveDate, IsActive) " +
                    "VALUES (@FullName, @Email, @Hash, 0, 1, 0, @Today, 1)",
                    DBHelper.Param("@FullName", fullName),
                    DBHelper.Param("@Email", email),
                    DBHelper.Param("@Hash", hash),
                    DBHelper.Param("@Today", DateTime.Today));
                return string.Empty;
            }
            catch (SqlException)
            {
                return "We couldn't create your account right now. Please try again.";
            }
        }

        public static Student LoginStudent(string email, string password)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT StudentID, FullName, Email, PasswordHash, XP, Level, StreakDays, LastActiveDate, IsActive " +
                "FROM Student WHERE Email = @Email",
                DBHelper.Param("@Email", email));

            if (dt.Rows.Count == 0) return null;

            DataRow row = dt.Rows[0];
            if (!(bool)row["IsActive"]) return null;
            if (!PasswordHelper.Verify(password, row["PasswordHash"].ToString())) return null;

            Student student = new Student
            {
                StudentID = Convert.ToInt32(row["StudentID"]),
                FullName = row["FullName"].ToString(),
                Email = row["Email"].ToString(),
                XP = Convert.ToInt32(row["XP"]),
                Level = Convert.ToInt32(row["Level"]),
                StreakDays = Convert.ToInt32(row["StreakDays"]),
                LastActiveDate = row["LastActiveDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(row["LastActiveDate"]),
                IsActive = true
            };

            StudentBLL.TouchStreak(student.StudentID);

            HttpContext.Current.Session[SessionStudentId] = student.StudentID;
            HttpContext.Current.Session[SessionStudentName] = student.FullName;
            return student;
        }

        public static bool IsStudentLoggedIn()
        {
            return HttpContext.Current.Session[SessionStudentId] != null;
        }

        public static int CurrentStudentId()
        {
            object val = HttpContext.Current.Session[SessionStudentId];
            return val == null ? 0 : Convert.ToInt32(val);
        }

        public static string CurrentStudentName()
        {
            object val = HttpContext.Current.Session[SessionStudentName];
            return val == null ? string.Empty : val.ToString();
        }

        // ---------------- Admin ----------------

        public static Admin LoginAdmin(string email, string password)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT AdminID, FullName, Email, PasswordHash FROM Admin WHERE Email = @Email",
                DBHelper.Param("@Email", email));

            if (dt.Rows.Count == 0) return null;

            DataRow row = dt.Rows[0];
            if (!PasswordHelper.Verify(password, row["PasswordHash"].ToString())) return null;

            var admin = new Admin
            {
                AdminID = Convert.ToInt32(row["AdminID"]),
                FullName = row["FullName"].ToString(),
                Email = row["Email"].ToString()
            };

            HttpContext.Current.Session[SessionAdminId] = admin.AdminID;
            HttpContext.Current.Session[SessionAdminName] = admin.FullName;
            return admin;
        }

        public static bool IsAdminLoggedIn()
        {
            return HttpContext.Current.Session[SessionAdminId] != null;
        }

        public static string CurrentAdminName()
        {
            object val = HttpContext.Current.Session[SessionAdminName];
            return val == null ? string.Empty : val.ToString();
        }

        // ---------------- Shared ----------------

        public static void Logout()
        {
            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();
        }

        public static void RequireStudent(HttpResponse response)
        {
            if (!IsStudentLoggedIn())
                response.Redirect("~/Login.aspx", true);
        }

        public static void RequireAdmin(HttpResponse response)
        {
            if (!IsAdminLoggedIn())
                response.Redirect("~/Admin/Login.aspx", true);
        }
    }
}
