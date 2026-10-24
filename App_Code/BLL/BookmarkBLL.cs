using System;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    /// <summary>Business rules for student bookmarks across lessons, materials and challenges.</summary>
    public static class BookmarkBLL
    {
        public static DataTable GetForStudent(int studentId)
        {
            return DBHelper.ExecuteQuery(
                "SELECT BookmarkID, ItemType, ItemID, Title, CreatedOn FROM Bookmark WHERE StudentID = @Id ORDER BY CreatedOn DESC",
                DBHelper.Param("@Id", studentId));
        }

        public static bool IsBookmarked(int studentId, string itemType, int itemId)
        {
            return Convert.ToInt32(DBHelper.ExecuteScalar(
                "SELECT COUNT(1) FROM Bookmark WHERE StudentID=@Sid AND ItemType=@Type AND ItemID=@Iid",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Type", itemType), DBHelper.Param("@Iid", itemId))) > 0;
        }

        public static void Add(int studentId, string itemType, int itemId, string title)
        {
            if (IsBookmarked(studentId, itemType, itemId)) return;

            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Bookmark (StudentID, ItemType, ItemID, Title) VALUES (@Sid, @Type, @Iid, @Title)",
                DBHelper.Param("@Sid", studentId), DBHelper.Param("@Type", itemType),
                DBHelper.Param("@Iid", itemId), DBHelper.Param("@Title", title));
        }

        public static void Remove(int bookmarkId, int studentId)
        {
            // StudentID check ensures a student can only delete their own bookmark.
            DBHelper.ExecuteNonQuery(
                "DELETE FROM Bookmark WHERE BookmarkID = @Id AND StudentID = @Sid",
                DBHelper.Param("@Id", bookmarkId), DBHelper.Param("@Sid", studentId));
        }
    }
}
