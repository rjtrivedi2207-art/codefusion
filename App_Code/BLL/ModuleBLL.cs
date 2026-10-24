using System;
using System.Collections.Generic;
using System.Data;
using CodeFusion.DAL;
using CodeFusion.Entities;

namespace CodeFusion.BLL
{
    /// <summary>Business rules for the 5 top-level learning Modules and their lesson-completion progress.</summary>
    public static class ModuleBLL
    {
        /// <summary>Every active module, with this student's lesson/completion counts for each one.</summary>
        public static List<Module> GetActiveModules(int studentId)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT M.ModuleID, M.ModuleTitle, M.Description, M.ModuleOrder, M.IsActive, M.CreatedDate, " +
                "       (SELECT COUNT(1) FROM Lesson L WHERE L.ModuleID = M.ModuleID AND L.IsPublished = 1) AS LessonCount, " +
                "       (SELECT COUNT(1) FROM Lesson L JOIN LessonProgress LP ON LP.LessonID = L.LessonID " +
                "        WHERE L.ModuleID = M.ModuleID AND L.IsPublished = 1 AND LP.StudentID = @Sid AND LP.IsCompleted = 1) AS DoneCount " +
                "FROM Module M " +
                "WHERE M.IsActive = 1 " +
                "ORDER BY M.ModuleOrder",
                DBHelper.Param("@Sid", studentId));

            var list = new List<Module>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new Module
                {
                    ModuleID = Convert.ToInt32(row["ModuleID"]),
                    ModuleTitle = row["ModuleTitle"].ToString(),
                    Description = row["Description"].ToString(),
                    ModuleOrder = Convert.ToInt32(row["ModuleOrder"]),
                    IsActive = Convert.ToBoolean(row["IsActive"]),
                    CreatedDate = Convert.ToDateTime(row["CreatedDate"]),
                    LessonCount = Convert.ToInt32(row["LessonCount"]),
                    CompletedLessonCount = Convert.ToInt32(row["DoneCount"])
                });
            }
            return list;
        }

        public static Module GetById(int moduleId, int studentId)
        {
            List<Module> all = GetActiveModules(studentId);
            return all.Find(m => m.ModuleID == moduleId);
        }

        // ---------------- Admin management ----------------

        public static DataTable GetAllModulesRaw()
        {
            return DBHelper.ExecuteQuery(
                "SELECT M.ModuleID, M.ModuleTitle, M.Description, M.ModuleOrder, M.IsActive, " +
                "       (SELECT COUNT(1) FROM Lesson L WHERE L.ModuleID = M.ModuleID) AS LessonCount " +
                "FROM Module M ORDER BY M.ModuleOrder");
        }

        public static void SaveModule(int moduleId, string title, string description, int moduleOrder, bool isActive)
        {
            if (moduleId == 0)
            {
                DBHelper.ExecuteInsertReturnId(
                    "INSERT INTO Module (ModuleTitle, Description, ModuleOrder, IsActive) VALUES (@Title, @Desc, @Order, @Active)",
                    DBHelper.Param("@Title", title), DBHelper.Param("@Desc", description),
                    DBHelper.Param("@Order", moduleOrder), DBHelper.Param("@Active", isActive));
            }
            else
            {
                DBHelper.ExecuteNonQuery(
                    "UPDATE Module SET ModuleTitle=@Title, Description=@Desc, ModuleOrder=@Order, IsActive=@Active WHERE ModuleID=@Id",
                    DBHelper.Param("@Title", title), DBHelper.Param("@Desc", description),
                    DBHelper.Param("@Order", moduleOrder), DBHelper.Param("@Active", isActive), DBHelper.Param("@Id", moduleId));
            }
        }

        /// <returns>Empty string on success, or a friendly message if the module still has lessons.</returns>
        public static string DeleteModule(int moduleId)
        {
            int lessonCount = Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Lesson WHERE ModuleID = @Id", DBHelper.Param("@Id", moduleId)));
            if (lessonCount > 0)
                return "This module still has " + lessonCount + " lesson(s). Delete or move them first, or deactivate the module instead.";

            DBHelper.ExecuteNonQuery("DELETE FROM Module WHERE ModuleID = @Id", DBHelper.Param("@Id", moduleId));
            return string.Empty;
        }
    }
}
