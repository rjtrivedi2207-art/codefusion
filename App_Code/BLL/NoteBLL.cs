using System;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    /// <summary>Business rules for personal student notes, optionally tied to a lesson.</summary>
    public static class NoteBLL
    {
        public static DataTable GetForStudent(int studentId)
        {
            return DBHelper.ExecuteQuery(
                "SELECT N.NoteID, N.NoteText, N.CreatedOn, N.UpdatedOn, N.LessonID, L.Title AS LessonTitle " +
                "FROM StudentNote N LEFT JOIN Lesson L ON L.LessonID = N.LessonID " +
                "WHERE N.StudentID = @Id ORDER BY N.CreatedOn DESC",
                DBHelper.Param("@Id", studentId));
        }

        public static void Create(int studentId, int? lessonId, string noteText)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO StudentNote (StudentID, LessonID, NoteText) VALUES (@Sid, @Lid, @Text)",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Lid", (object)lessonId ?? DBNull.Value), DBHelper.Param("@Text", noteText));
        }

        public static void Update(int noteId, int studentId, string noteText)
        {
            DBHelper.ExecuteNonQuery(
                "UPDATE StudentNote SET NoteText = @Text, UpdatedOn = @Now WHERE NoteID = @Id AND StudentID = @Sid",
                DBHelper.Param("@Text", noteText), DBHelper.Param("@Now", DateTime.Now),
                DBHelper.Param("@Id", noteId), DBHelper.Param("@Sid", studentId));
        }

        public static void Delete(int noteId, int studentId)
        {
            DBHelper.ExecuteNonQuery(
                "DELETE FROM StudentNote WHERE NoteID = @Id AND StudentID = @Sid",
                DBHelper.Param("@Id", noteId), DBHelper.Param("@Sid", studentId));
        }
    }
}
