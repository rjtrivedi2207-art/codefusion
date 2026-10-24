using System;
using System.Collections.Generic;
using System.Data;
using System.Text.RegularExpressions;
using CodeFusion.DAL;
using CodeFusion.Entities;

namespace CodeFusion.BLL
{
    /// <summary>
    /// Business rules for the Employee CRUD Lab. Validates input, then delegates
    /// the actual SQL to DBHelper — code-behind never touches SqlCommand directly.
    /// </summary>
    public static class EmployeeBLL
    {
        private static readonly Regex EmailPattern = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");

        public static List<Employee> GetAll()
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT EmployeeID, Name, Email, Department, Salary FROM Employee ORDER BY EmployeeID DESC");

            var list = new List<Employee>();
            foreach (DataRow row in dt.Rows)
            {
                list.Add(new Employee
                {
                    EmployeeID = Convert.ToInt32(row["EmployeeID"]),
                    Name = row["Name"].ToString(),
                    Email = row["Email"].ToString(),
                    Department = row["Department"].ToString(),
                    Salary = Convert.ToDecimal(row["Salary"])
                });
            }
            return list;
        }

        public static Employee GetById(int id)
        {
            DataTable dt = DBHelper.ExecuteQuery(
                "SELECT EmployeeID, Name, Email, Department, Salary FROM Employee WHERE EmployeeID = @Id",
                DBHelper.Param("@Id", id));
            if (dt.Rows.Count == 0) return null;

            DataRow row = dt.Rows[0];
            return new Employee
            {
                EmployeeID = Convert.ToInt32(row["EmployeeID"]),
                Name = row["Name"].ToString(),
                Email = row["Email"].ToString(),
                Department = row["Department"].ToString(),
                Salary = Convert.ToDecimal(row["Salary"])
            };
        }

        public static string Validate(Employee emp)
        {
            if (string.IsNullOrWhiteSpace(emp.Name)) return "Name is required.";
            if (string.IsNullOrWhiteSpace(emp.Email) || !EmailPattern.IsMatch(emp.Email)) return "A valid email is required.";
            if (string.IsNullOrWhiteSpace(emp.Department)) return "Department is required.";
            if (emp.Salary <= 0) return "Salary must be greater than zero.";
            return string.Empty;
        }

        public static string Create(Employee emp)
        {
            string error = Validate(emp);
            if (error != string.Empty) return error;

            DBHelper.ExecuteInsertReturnId(
                "INSERT INTO Employee (Name, Email, Department, Salary) VALUES (@Name, @Email, @Dept, @Salary)",
                DBHelper.Param("@Name", emp.Name),
                DBHelper.Param("@Email", emp.Email),
                DBHelper.Param("@Dept", emp.Department),
                DBHelper.Param("@Salary", emp.Salary));
            return string.Empty;
        }

        public static string Update(Employee emp)
        {
            string error = Validate(emp);
            if (error != string.Empty) return error;

            DBHelper.ExecuteNonQuery(
                "UPDATE Employee SET Name = @Name, Email = @Email, Department = @Dept, Salary = @Salary WHERE EmployeeID = @Id",
                DBHelper.Param("@Name", emp.Name),
                DBHelper.Param("@Email", emp.Email),
                DBHelper.Param("@Dept", emp.Department),
                DBHelper.Param("@Salary", emp.Salary),
                DBHelper.Param("@Id", emp.EmployeeID));
            return string.Empty;
        }

        public static void Delete(int id)
        {
            DBHelper.ExecuteNonQuery("DELETE FROM Employee WHERE EmployeeID = @Id", DBHelper.Param("@Id", id));
        }
    }
}
