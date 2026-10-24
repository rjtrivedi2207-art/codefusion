using System;
using System.Data;
using CodeFusion.DAL;

namespace CodeFusion.BLL
{
    public class MaterialItem
    {
        public int MaterialID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Topic { get; set; }
        public string MaterialType { get; set; }
        public string FilePath { get; set; }
        public string TextContent { get; set; }
    }

    /// <summary>Business rules for study materials: browse/search/filter for students, manage for admins.</summary>
    public static class MaterialBLL
    {
        public static DataTable Search(string keyword, string topic)
        {
            string sql = "SELECT MaterialID, Title, Description, Topic, MaterialType, FilePath, TextContent, UploadedOn FROM Material WHERE 1=1";
            var paramList = new System.Collections.Generic.List<System.Data.SqlClient.SqlParameter>();

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                sql += " AND (Title LIKE @Kw OR Description LIKE @Kw)";
                paramList.Add(DBHelper.Param("@Kw", "%" + keyword + "%"));
            }
            if (!string.IsNullOrWhiteSpace(topic))
            {
                sql += " AND Topic = @Topic";
                paramList.Add(DBHelper.Param("@Topic", topic));
            }
            sql += " ORDER BY UploadedOn DESC";

            return DBHelper.ExecuteQuery(sql, paramList.ToArray());
        }

        public static DataTable GetAllTopics()
        {
            return DBHelper.ExecuteQuery("SELECT DISTINCT Topic FROM Material ORDER BY Topic");
        }

        public static void AddTextMaterial(string title, string description, string topic, string textContent)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Material (Title, Description, Topic, MaterialType, TextContent) VALUES (@Title, @Desc, @Topic, 'Text', @Text)",
                DBHelper.Param("@Title", title), DBHelper.Param("@Desc", description),
                DBHelper.Param("@Topic", topic), DBHelper.Param("@Text", textContent));
        }

        public static void AddPdfMaterial(string title, string description, string topic, string filePath)
        {
            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Material (Title, Description, Topic, MaterialType, FilePath) VALUES (@Title, @Desc, @Topic, 'PDF', @Path)",
                DBHelper.Param("@Title", title), DBHelper.Param("@Desc", description),
                DBHelper.Param("@Topic", topic), DBHelper.Param("@Path", filePath));
        }

        public static void Delete(int materialId)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM Bookmark WHERE ItemType = 'Material' AND ItemID = @Id", DBHelper.Param("@Id", materialId));
            DBHelper.ExecuteNonQuery("DELETE FROM Material WHERE MaterialID = @Id", DBHelper.Param("@Id", materialId));
        }
    }
}
