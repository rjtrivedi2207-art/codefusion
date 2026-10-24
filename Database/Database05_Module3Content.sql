/* =====================================================================
   CodeFusion — Module 3 content: Database, SQL and Data Storage (7 lessons)
   Run this ONCE against your existing CodeFusionDB.
   ===================================================================== */
USE CodeFusionDB;
GO
SET NOCOUNT ON;

DECLARE @Mod3 INT = (SELECT ModuleID FROM Module WHERE ModuleOrder = 3);

INSERT INTO Lesson
    (ModuleID, Title, ShortDescription, LearningObjectives, Explanation, Syntax, CodeExample, CodeExplanation,
     ExpectedOutput, RealWorldUse, CommonMistakes, Troubleshooting, PracticeTask, KeyPoints, CodeLanguage, DisplayOrder, IsPublished)
VALUES
-- Lesson 14
(@Mod3,
 N'Introduction to SQL Server and Databases',
 N'What a database is, how SQL Server stores data in tables, and where LocalDB fits in.',
 N'Explain what a database, table, row and column are|Describe what SQL Server and LocalDB are|Identify the tables that make up the CodeFusion database',
 N'Almost every real web application needs to remember things: who registered, which lessons they finished, what score they got on a quiz. Anything held only inside a page or a variable disappears when the visitor leaves, so applications store this information in a database — an organised collection of data that lives on disk, outside any single page, and survives restarts.

A relational database such as SQL Server organises its data into tables. A table is like a spreadsheet with a fixed set of columns (the kinds of facts you store, such as FullName and Email) and any number of rows (one entry each, such as one student). The Student table in CodeFusion has one row for every registered student, and each row holds that student''s name, email, XP and so on. One database holds many tables: CodeFusionDB contains Student, Lesson, Module, Quiz, Employee and others.

SQL Server is Microsoft''s database engine — the program that stores the tables, answers questions about them, and enforces rules. LocalDB is a lightweight version of the same engine that Visual Studio installs for developers, so you can build and test an application without setting up a full server. CodeFusion connects to LocalDB while you develop, and the same code can later connect to a full SQL Server by changing only the connection string.

You talk to the database using SQL (Structured Query Language), a small, readable language made of commands such as SELECT, INSERT, UPDATE and DELETE. Your ASP.NET code never reads database files directly. It sends SQL commands to SQL Server and receives the results back. The rest of this module teaches exactly how that conversation works.',
 N'SELECT column1, column2 FROM TableName;',
 N'-- The Student table, one row per student:
-- StudentID | FullName    | Email              | XP
-- 1         | Aarav Shah  | aarav@example.com  | 30
-- 2         | Priya Mehta | priya@example.com  | 10

SELECT StudentID, FullName, Email, XP
FROM Student;',
 N'Lines starting with two dashes are comments — SQL ignores them, and here they show what the table looks like.|SELECT StudentID, FullName, Email, XP lists exactly which columns you want back; you can ask for fewer columns than the table has.|FROM Student names the table to read from.|The semicolon marks the end of the statement.',
 N'SQL Server returns a result grid with one row per student and four columns: StudentID, FullName, Email and XP. If the table is empty you still get the column headings, but no rows.',
 N'Every feature in CodeFusion that remembers anything — your XP, completed lessons, quiz history, bookmarks, notes — is simply rows in tables inside CodeFusionDB, read and written by SQL commands sent from the C# code.',
 N'Confusing a database with a table — one database holds many tables.|Assuming data kept in a variable, ViewState or Session is permanent — only data saved in the database survives after the visitor leaves or the server restarts.',
 N'If SQL Server Object Explorer shows no CodeFusionDB, check you expanded the correct LocalDB instance (MSSQLLocalDB) and that you ran the database scripts against it.|If a query says Invalid object name, the table does not exist in the database you are connected to — check the database name first.',
 N'In Visual Studio open SQL Server Object Explorer, expand (localdb)\MSSQLLocalDB, then CodeFusionDB, then Tables. Write down five table names, then right-click Student and choose View Data.',
 N'A database holds many tables|A table has columns (kinds of facts) and rows (individual entries)|SQL Server is the engine, LocalDB is its lightweight developer version|ASP.NET talks to the database by sending SQL commands', N'SQL', 1, 1),

-- Lesson 15
(@Mod3,
 N'Tables, Primary Keys and Relationships',
 N'How rows are uniquely identified, and how tables link to each other using keys.',
 N'Explain what a primary key is and why every table needs one|Explain what a foreign key is and what it protects|Describe a one-to-many relationship using CodeFusion tables',
 N'If two students are both named Aarav Shah, how does the database know which row is which? Every table therefore has a primary key: a column (or set of columns) whose value is unique for every row. In CodeFusion, StudentID is the primary key of the Student table. It is declared IDENTITY(1,1), which means SQL Server numbers new rows automatically — 1, 2, 3 and so on — so your code never has to invent IDs.

Tables rarely stand alone. A student completes many lessons, and each lesson can be completed by many students. Instead of copying a student''s name into every progress row, the LessonProgress table stores only the StudentID. That column is a foreign key: a column whose values must match a primary key value in another table. This is called a relationship — here, one student has many progress rows (one-to-many).

Foreign keys also protect your data. If you try to insert a LessonProgress row for StudentID 999 and no such student exists, SQL Server refuses with an error. This rule is called referential integrity. Options like ON DELETE CASCADE (used in CodeFusion) say what should happen to child rows when a parent row is deleted: the progress rows are deleted along with the student.

Other useful constraints appear in the example below: NOT NULL means a value is required, and UNIQUE means no two rows may share that value — which is how CodeFusion prevents two accounts with the same email.',
 N'CREATE TABLE TableName (
    ColumnName DataType CONSTRAINTS
);',
 N'-- Simplified version of two CodeFusion tables
CREATE TABLE Student (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName  NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE LessonProgress (
    LessonProgressID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID   INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID),
    LessonID    INT NOT NULL,
    IsCompleted BIT NOT NULL DEFAULT 0
);',
 N'StudentID INT IDENTITY(1,1) PRIMARY KEY: an integer column, auto-numbered starting at 1 going up by 1, and unique for every row.|Email ... NOT NULL UNIQUE: an email is required, and no two students may share one.|StudentID INT NOT NULL FOREIGN KEY REFERENCES Student(StudentID): this column in LessonProgress must always contain a StudentID that exists in the Student table.|IsCompleted BIT NOT NULL DEFAULT 0: BIT stores true or false, and new rows start as not completed unless told otherwise.',
 N'Running the script creates two empty tables. Inserting a LessonProgress row with a StudentID that does not exist in Student fails with an error mentioning a FOREIGN KEY conflict, which proves the relationship is being enforced.',
 N'These two tables are the same pattern CodeFusion uses to track lesson completion: Student and Lesson are linked through LessonProgress, so one student can have many completed lessons without any data being duplicated.',
 N'Choosing a column like Name as the primary key — names are not unique, so use a numeric ID instead.|Inserting child rows before the parent row exists — the foreign key rejects them. Insert the student first, then their progress.',
 N'If an INSERT fails with a conflict with the FOREIGN KEY constraint, the ID you supplied does not exist in the parent table yet.|If an INSERT fails with a violation of UNIQUE KEY constraint, a row with that value (for example that email) already exists.',
 N'Open 01_CreateDatabase.sql in the Database folder of this project and find the LessonProgress table. Identify its primary key, its two foreign keys, and the UNIQUE constraint.',
 N'A primary key uniquely identifies every row|IDENTITY lets SQL Server generate the numbers automatically|A foreign key links a column to another table''s primary key|Constraints such as NOT NULL and UNIQUE protect data quality', N'SQL', 2, 1),

-- Lesson 16
(@Mod3,
 N'Connection Strings and Database Connectivity',
 N'How an ASP.NET application is told which server and database to talk to.',
 N'Read each part of a SQL Server connection string|Explain why the connection string lives in Web.config|Load a connection string from C# using ConfigurationManager',
 N'Before your code can send any SQL, it must know which database engine to contact and which database inside it to use. That information is packaged into a single piece of text called a connection string — a list of Name=Value pairs separated by semicolons.

The important parts are: Server (which SQL Server instance — for LocalDB this is (localdb)\MSSQLLocalDB), Database (which database on that server — CodeFusionDB), and Trusted_Connection=True, which means "log in using my Windows account" so no password is needed in the text. TrustServerCertificate=True simply avoids certificate warnings on a development machine.

The connection string should never be typed into individual pages. It lives once in Web.config, inside the connectionStrings section, under a name. Every database call then reads it by that name. If the project moves to a different server, you edit one line in one file and no C# changes at all. In CodeFusion, the single class DBHelper in App_Code/DAL reads the string "CodeFusionDB" and hands out connections, which is why no page ever contains a server name.

Treat connection strings as sensitive: they can contain passwords in other setups, so they must never be shown to users, which is exactly why this project''s custom error pages hide raw database errors.',
 N'Server=...;Database=...;Trusted_Connection=True;',
 N'<!-- Web.config -->
<connectionStrings>
  <add name="CodeFusionDB"
       connectionString="Server=(localdb)\MSSQLLocalDB;Database=CodeFusionDB;Trusted_Connection=True;"
       providerName="System.Data.SqlClient" />
</connectionStrings>

// C# (needs: using System.Configuration; using System.Data.SqlClient;)
string cs = ConfigurationManager.ConnectionStrings["CodeFusionDB"].ConnectionString;
SqlConnection con = new SqlConnection(cs);',
 N'name="CodeFusionDB" is the label your C# code uses to find this setting.|Server=(localdb)\MSSQLLocalDB picks the LocalDB instance; Database=CodeFusionDB picks the database inside it.|Trusted_Connection=True logs in with the current Windows user instead of a username and password.|ConfigurationManager.ConnectionStrings["CodeFusionDB"] looks the setting up by that name and returns the text.|new SqlConnection(cs) creates a connection object ready to be opened — creating it does not contact the database yet.',
 N'Nothing is displayed. If the connection string is correct, later code can open the connection successfully; if the Server or Database is wrong, opening it throws a SqlException such as Cannot open database requested by the login.',
 N'This is exactly how CodeFusion works: every page that touches data goes through DBHelper, which reads this one connection string. Changing the instance name here moves the whole application to another database server.',
 N'Hard-coding the connection string inside a page, so changing servers means editing many files.|Pointing the connection string at the wrong LocalDB instance, so the database seems to be missing even though it exists elsewhere.',
 N'If you see Cannot open database CodeFusionDB requested by the login, either the database does not exist on that server or the Server value points at the wrong instance.|If you see A network-related or instance-specific error, SQL Server (or LocalDB) is not running or the server name is misspelled.',
 N'Open Web.config in this project, find the CodeFusionDB connection string, and write down its Server and Database values. Then open App_Code/DAL/DBHelper.cs and find where that name is used.',
 N'A connection string tells ASP.NET which server and database to use|It belongs in Web.config, not in individual pages|ConfigurationManager.ConnectionStrings reads it by name|Creating a SqlConnection does not open it', N'CSharp', 3, 1),

-- Lesson 17
(@Mod3,
 N'ADO.NET: SqlConnection and SqlCommand',
 N'The core ADO.NET objects that carry SQL from C# to SQL Server, and the three ways to execute a command.',
 N'Explain the roles of SqlConnection, SqlCommand and SqlDataReader|Choose between ExecuteScalar, ExecuteNonQuery and ExecuteReader|Use a using block so connections are always closed',
 N'ADO.NET is the set of .NET classes for working with databases. Three of them do most of the work. SqlConnection represents the open line to the database. SqlCommand holds one SQL statement and sends it over that connection. SqlDataReader reads the rows of a result one at a time, forward only, which makes it fast and light.

A SqlCommand can be executed in three main ways, and choosing the right one matters. ExecuteScalar returns a single value — the first column of the first row — and is perfect for queries like SELECT COUNT(*). ExecuteNonQuery runs a statement that changes data (INSERT, UPDATE, DELETE) and returns how many rows were affected. ExecuteReader runs a SELECT and returns a SqlDataReader so you can loop through many rows.

Connections are limited resources. Every connection you open must be closed, even if an error occurs halfway through. The using statement guarantees this: when the block ends, the object is disposed and the connection is closed automatically, whether the code succeeded or threw an exception. Nearly every database method in CodeFusion is wrapped in using blocks for this reason.

Remember the order: create the connection, create the command, open the connection, execute, then let the using block clean up. Opening the connection as late as possible keeps it open for the shortest time.',
 N'using (SqlConnection con = new SqlConnection(cs))
using (SqlCommand cmd = new SqlCommand(sql, con))
{
    con.Open();
    // cmd.ExecuteScalar() / ExecuteNonQuery() / ExecuteReader()
}',
 N'using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Student", con))
{
    con.Open();
    int total = Convert.ToInt32(cmd.ExecuteScalar());
    lblTotal.Text = "Total students: " + total;
}',
 N'DBHelper.GetConnection() returns a SqlConnection built from the Web.config connection string — the connection exists but is not open yet.|new SqlCommand("SELECT COUNT(*) ...", con) pairs one SQL statement with that connection.|con.Open() opens the line to SQL Server just before it is needed.|cmd.ExecuteScalar() runs the statement and returns the single value from the first row and column; Convert.ToInt32 turns that object into an int.|When the closing brace is reached, the using blocks close the command and the connection automatically.',
 N'The label shows something like Total students: 12, the number of rows currently in the Student table.',
 N'This is the shape of almost every database call in CodeFusion. DBHelper simply wraps this pattern so that pages and business classes never repeat connection handling.',
 N'Forgetting con.Open() before executing — this throws an InvalidOperationException saying the connection is closed.|Using ExecuteReader or ExecuteScalar for an INSERT, UPDATE or DELETE — use ExecuteNonQuery for statements that change data.',
 N'If you see ExecuteScalar requires an open and available Connection, you forgot con.Open().|If a page becomes slow or times out after many requests, connections may not be closing — check every connection is inside a using block.',
 N'Open App_Code/DAL/DBHelper.cs and find the three methods ExecuteQuery, ExecuteNonQuery and ExecuteScalar. For each, write down which ADO.NET command method it calls and why.',
 N'SqlConnection is the line to the database, SqlCommand carries the SQL|ExecuteScalar returns one value, ExecuteNonQuery returns rows affected, ExecuteReader returns rows|using blocks close connections automatically, even after errors|Open the connection as late as possible', N'CSharp', 4, 1),

-- Lesson 18
(@Mod3,
 N'SELECT Queries in ASP.NET',
 N'Reading rows from SQL Server with SELECT, and getting them into C# with SqlDataReader or a DataTable.',
 N'Write a SELECT that chooses specific columns and filters rows|Read rows with SqlDataReader inside a while loop|Bind query results to a GridView using a DataTable',
 N'SELECT is the command for reading data. SELECT * FROM Employee returns every column of every row. It is usually better to name only the columns you need, and to add a WHERE clause so the database filters rows for you, instead of loading everything and filtering in C#.

To use the result in ASP.NET there are two common approaches. The first is SqlDataReader: call cmd.ExecuteReader(), then loop with while (reader.Read()). Each call to Read() moves to the next row, and reader["ColumnName"] gives that column''s value as an object that you convert to the type you need. The reader is forward-only and keeps the connection busy while you loop, so read what you need and finish quickly.

The second approach is to fill a DataTable with a SqlDataAdapter, which loads all rows into memory at once. A DataTable can then be assigned straight to a GridView''s DataSource, which is what CodeFusion''s DBHelper.ExecuteQuery does. Use the reader when you process rows one by one, and the DataTable when you simply want to display a table.

Notice the @Department in the query below. That is a parameter: a placeholder whose value is supplied separately by cmd.Parameters.AddWithValue. This is the only safe way to put user input into a query, and Lesson 20 explains why in detail. For now, remember: never join user input into SQL text.',
 N'SELECT column1, column2
FROM TableName
WHERE condition;',
 N'-- SQL
SELECT Name, Salary FROM Employee WHERE Department = @Department;

// C#
using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand(
    "SELECT Name, Salary FROM Employee WHERE Department = @Department", con))
{
    cmd.Parameters.AddWithValue("@Department", "Engineering");
    con.Open();
    using (SqlDataReader reader = cmd.ExecuteReader())
    {
        while (reader.Read())
        {
            string name = reader["Name"].ToString();
            decimal salary = Convert.ToDecimal(reader["Salary"]);
        }
    }
}',
 N'The SQL asks for only two columns, and WHERE keeps only employees in the requested department.|AddWithValue("@Department", "Engineering") supplies the value for the placeholder — the value never becomes part of the SQL text.|cmd.ExecuteReader() runs the SELECT and returns a SqlDataReader positioned before the first row.|while (reader.Read()) moves to the next row each time and stops automatically when there are no more rows.|reader["Name"] fetches a column by name as an object; ToString and Convert.ToDecimal turn it into the type you want.',
 N'For the sample data, the loop runs once for each Engineering employee, for example Aarav Shah with salary 45000. Employees from other departments are never returned.',
 N'The Employee list in the CRUD Lab, the quiz list in Quiz Arena and the lesson list on the Learning page are all produced by SELECT queries like this one, sent through DBHelper and shown in a GridView or Repeater.',
 N'Using SELECT * everywhere — it loads columns you do not need and breaks easily when the table changes.|Reading a column that is not in the SELECT list, which throws an IndexOutOfRangeException.',
 N'If reader["Name"] throws IndexOutOfRangeException, the column name is misspelled or was not included in the SELECT list.|If a query returns no rows when you expect some, check the WHERE value for spelling and capitalisation, and confirm rows actually exist in the table.',
 N'Open App_Code/BLL/EmployeeBLL.cs and find GetAll. Identify the SELECT statement it sends and explain how the returned rows end up displayed in the CRUD Lab''s GridView.',
 N'SELECT reads data; name only the columns you need|WHERE filters rows inside the database|SqlDataReader loops through rows with while (reader.Read())|A DataTable can be assigned directly to a GridView', N'CSharp', 5, 1),

-- Lesson 19
(@Mod3,
 N'INSERT, UPDATE and DELETE Queries',
 N'Changing data in SQL Server from C#, and why WHERE is essential on UPDATE and DELETE.',
 N'Write INSERT, UPDATE and DELETE statements for the Employee table|Run them with ExecuteNonQuery and read the rows-affected count|Explain what happens if UPDATE or DELETE has no WHERE clause',
 N'Three statements change the data in a table. INSERT INTO adds a new row, listing the columns and then the VALUES to store. UPDATE changes values in existing rows, using SET to say what changes. DELETE FROM removes rows. Together with SELECT, these four make up CRUD: Create, Read, Update, Delete.

In ADO.NET all three are run with cmd.ExecuteNonQuery(). It returns an int: the number of rows the statement affected. That number is useful feedback — if an UPDATE returns 0, no row matched your WHERE condition, which usually means the ID was wrong.

The most dangerous mistake in SQL is forgetting the WHERE clause on UPDATE or DELETE. UPDATE Employee SET Salary = 0 changes every row in the table. DELETE FROM Employee deletes every row. The database will not ask for confirmation. Always include a WHERE that identifies the row, normally by its primary key — for example WHERE EmployeeID = @Id.

As with SELECT, every value from the user must be passed as a parameter. Your page might receive a name like O''Brien containing an apostrophe; with parameters this works perfectly, while text-joined SQL would break or, worse, be exploited. CodeFusion''s EmployeeBLL uses exactly these three statements for the CRUD Lab.',
 N'INSERT INTO Table (Col1, Col2) VALUES (@A, @B);
UPDATE Table SET Col1 = @A WHERE KeyCol = @Id;
DELETE FROM Table WHERE KeyCol = @Id;',
 N'-- SQL
INSERT INTO Employee (Name, Email, Department, Salary)
VALUES (@Name, @Email, @Dept, @Salary);

UPDATE Employee SET Salary = @Salary WHERE EmployeeID = @Id;

DELETE FROM Employee WHERE EmployeeID = @Id;

// C# - the UPDATE
using (SqlConnection con = DBHelper.GetConnection())
using (SqlCommand cmd = new SqlCommand(
    "UPDATE Employee SET Salary = @Salary WHERE EmployeeID = @Id", con))
{
    cmd.Parameters.AddWithValue("@Salary", 50000);
    cmd.Parameters.AddWithValue("@Id", 3);
    con.Open();
    int rows = cmd.ExecuteNonQuery();
    lblResult.Text = rows + " row(s) updated";
}',
 N'INSERT lists the columns, then the matching VALUES placeholders in the same order.|UPDATE ... SET changes the Salary, and WHERE EmployeeID = @Id limits the change to exactly one employee.|DELETE FROM ... WHERE removes only the row whose ID matches.|Both parameters are added before the connection opens; the values never become part of the SQL text.|ExecuteNonQuery returns the number of rows changed, which the label displays.',
 N'If an employee with ID 3 exists, the label shows 1 row(s) updated and that employee''s salary becomes 50000. If no employee has ID 3, it shows 0 row(s) updated and nothing changes.',
 N'The Employee CRUD Lab, the Admin panel''s lesson and module forms, and every Save or Delete button in CodeFusion ultimately run one of these three statements through ExecuteNonQuery.',
 N'Forgetting WHERE on UPDATE or DELETE, which changes or removes every row in the table.|Supplying a different number or order of values than columns in an INSERT, which causes an error or stores data in the wrong columns.',
 N'If rows affected is 0, your WHERE condition matched nothing — check the ID.|If an INSERT fails with Cannot insert the value NULL into column, a required (NOT NULL) column was not given a value.',
 N'Open App_Code/BLL/EmployeeBLL.cs and find Create, Update and Delete. For each one, write down the SQL statement and the ADO.NET method used to run it.',
 N'INSERT adds rows, UPDATE changes rows, DELETE removes rows|All three run with ExecuteNonQuery, which returns rows affected|Always use WHERE on UPDATE and DELETE|Pass every user value as a parameter', N'CSharp', 6, 1),

-- Lesson 20
(@Mod3,
 N'Parameters, WHERE, ORDER BY, LIKE and Basic JOINs',
 N'Safe parameterised queries, sorting, searching, summarising with COUNT/SUM/AVG/GROUP BY, and combining tables with JOIN.',
 N'Explain what SQL injection is and how parameters prevent it|Use ORDER BY, LIKE, COUNT, SUM, AVG and GROUP BY in queries|Combine two tables with a basic INNER JOIN',
 N'Parameters. If you build a query by joining text, like "SELECT * FROM Student WHERE Email = ''" + email + "''", a user can type SQL into the email box and change the meaning of your query. This attack is called SQL injection and is one of the most common ways websites are broken into. A parameter fixes it completely: the SQL text contains a placeholder such as @Email, and the value is sent separately, so it is always treated as data, never as SQL. Every query in CodeFusion uses parameters.

Sorting and searching. WHERE filters rows. ORDER BY sorts the results (add DESC for descending). LIKE searches for text patterns, where % matches any run of characters: Name LIKE ''%an%'' finds names containing "an". When the search word comes from the user, pass it as a parameter and add the % signs in C#.

Summarising. COUNT counts rows, SUM adds a numeric column, AVG averages it. GROUP BY lets you get one summary row per group — for example the average salary for each department.

Joining tables. Data is split across related tables, so a JOIN combines them. INNER JOIN returns rows where the key matches in both tables: for example each quiz Result joined to the Student who took it, using Result.StudentID = Student.StudentID. Short aliases like R and S keep the query readable.',
 N'SELECT ... FROM A
INNER JOIN B ON A.Key = B.Key
WHERE ... GROUP BY ... ORDER BY ...;',
 N'-- SQL: search + sort
SELECT Name, Salary FROM Employee
WHERE Name LIKE @Search
ORDER BY Salary DESC;

-- SQL: summary per group
SELECT Department, COUNT(*) AS Total, AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY Department;

-- SQL: join two tables
SELECT S.FullName, R.Score, R.TotalMarks
FROM Result R
INNER JOIN Student S ON S.StudentID = R.StudentID;

// C# - LIKE with a parameter
cmd.Parameters.AddWithValue("@Search", "%" + keyword + "%");',
 N'LIKE @Search ORDER BY Salary DESC finds matching names and lists the highest salary first.|GROUP BY Department produces one row per department; COUNT(*) and AVG(Salary) are calculated inside each group.|AS Total and AS AvgSalary give the calculated columns readable names.|INNER JOIN ... ON S.StudentID = R.StudentID pairs each result with the student who earned it, so you can show names instead of ID numbers.|The C# line adds the % wildcards around the keyword and passes the whole pattern as a parameter, which keeps the search safe.',
 N'The first query lists matching employees from highest to lowest salary. The second returns one row per department, such as Engineering with its count and average salary. The third returns each quiz attempt with the student''s full name beside the score.',
 N'The student search box in the Admin panel and the materials search both use LIKE with parameters, the Admin Results page joins Result, Student and Quiz so it can show names and titles, and dashboards use COUNT to show totals.',
 N'Building SQL by joining user text — it is vulnerable to SQL injection even if it appears to work in testing.|Selecting a non-grouped column together with an aggregate and forgetting it in GROUP BY, which causes an error.',
 N'If a query says Column is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause, add the column to GROUP BY or aggregate it.|If a JOIN returns no rows, the ON condition matches nothing — check you are comparing the correct key columns.',
 N'Open App_Code/BLL/AdminBLL.cs and find SearchStudents and GetAllResults. Identify which one uses LIKE, which one uses a JOIN, and how the user''s search text is passed safely.',
 N'Parameters keep user input out of the SQL text and stop SQL injection|ORDER BY sorts, LIKE with % searches text|COUNT, SUM and AVG summarise; GROUP BY summarises per group|INNER JOIN combines related tables using their key columns', N'SQL', 7, 1);

PRINT '--- Module 3: 7 lessons inserted ---';
GO

-- ---------- Mini quiz questions (3 per lesson) ----------
DECLARE @L14 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Introduction to SQL Server and Databases');
DECLARE @L15 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Tables, Primary Keys and Relationships');
DECLARE @L16 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Connection Strings and Database Connectivity');
DECLARE @L17 INT = (SELECT LessonID FROM Lesson WHERE Title = N'ADO.NET: SqlConnection and SqlCommand');
DECLARE @L18 INT = (SELECT LessonID FROM Lesson WHERE Title = N'SELECT Queries in ASP.NET');
DECLARE @L19 INT = (SELECT LessonID FROM Lesson WHERE Title = N'INSERT, UPDATE and DELETE Queries');
DECLARE @L20 INT = (SELECT LessonID FROM Lesson WHERE Title = N'Parameters, WHERE, ORDER BY, LIKE and Basic JOINs');

INSERT INTO LessonQuizQuestion (LessonID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption, DisplayOrder) VALUES
(@L14, N'In a table, what does one row represent?', N'A kind of fact', N'One entry such as one student', N'The whole database', N'A SQL command', 'B', 1),
(@L14, N'What is LocalDB?', N'A lightweight developer version of SQL Server', N'A web browser', N'A CSS framework', N'A type of table', 'A', 2),
(@L14, N'Which language do you use to ask a database for data?', N'HTML', N'CSS', N'SQL', N'JavaScript', 'C', 3),

(@L15, N'What does a primary key do?', N'Encrypts the table', N'Uniquely identifies every row', N'Sorts the rows', N'Deletes duplicates automatically', 'B', 1),
(@L15, N'What is a foreign key?', N'A column linking to another table''s primary key', N'A password column', N'A backup of the table', N'A sorting rule', 'A', 2),
(@L15, N'What does the UNIQUE constraint on Email prevent?', N'Empty emails', N'Two rows sharing the same email', N'Long emails', N'Uppercase emails', 'B', 3),

(@L16, N'Where should a connection string normally be stored?', N'In every page', N'In Web.config', N'In a CSS file', N'In a Label', 'B', 1),
(@L16, N'What does Trusted_Connection=True mean?', N'Log in using the current Windows account', N'Skip the database', N'Use a random password', N'Encrypt all data', 'A', 2),
(@L16, N'Which class reads a connection string from Web.config?', N'Page', N'ConfigurationManager', N'Response', N'GridView', 'B', 3),

(@L17, N'Which method returns a single value such as a COUNT?', N'ExecuteReader', N'ExecuteNonQuery', N'ExecuteScalar', N'Open', 'C', 1),
(@L17, N'Which method should run an INSERT, UPDATE or DELETE?', N'ExecuteNonQuery', N'ExecuteScalar', N'Read', N'Fill', 'A', 2),
(@L17, N'Why wrap connections in using blocks?', N'To make queries faster', N'So they are always closed, even after an error', N'To rename the database', N'It is only a style choice', 'B', 3),

(@L18, N'What does the WHERE clause do in a SELECT?', N'Sorts the rows', N'Filters which rows are returned', N'Deletes rows', N'Creates a table', 'B', 1),
(@L18, N'Which loop reads rows from a SqlDataReader?', N'for (int i = 0; i < 10; i++)', N'while (reader.Read())', N'foreach (Page p in reader)', N'if (reader.Open())', 'B', 2),
(@L18, N'What can be assigned directly to a GridView''s DataSource?', N'A DataTable', N'A connection string', N'A Button', N'A CSS class', 'A', 3),

(@L19, N'What does ExecuteNonQuery return?', N'The first column value', N'The number of rows affected', N'A SqlDataReader', N'The table name', 'B', 1),
(@L19, N'What happens if you run DELETE FROM Employee with no WHERE?', N'Nothing', N'Only the first row is deleted', N'Every row in the table is deleted', N'The table is renamed', 'C', 2),
(@L19, N'Which statement adds a new row?', N'SELECT', N'INSERT INTO', N'UPDATE', N'ORDER BY', 'B', 3),

(@L20, N'What does a SQL parameter protect against?', N'Slow queries', N'SQL injection', N'Missing tables', N'Duplicate emails', 'B', 1),
(@L20, N'Which keyword sorts results?', N'GROUP BY', N'WHERE', N'ORDER BY', N'LIKE', 'C', 2),
(@L20, N'Which join returns only rows that match in both tables?', N'INNER JOIN', N'DROP JOIN', N'COUNT JOIN', N'LIKE JOIN', 'A', 3);

PRINT '--- Module 3: mini quiz questions inserted ---';
GO

-- ---------- Verification (self-contained, no variables carried over GO) ----------
SELECT
    (SELECT COUNT(*) FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 3)) AS Module3LessonCount,
    (SELECT COUNT(*) FROM LessonQuizQuestion WHERE LessonID IN
        (SELECT LessonID FROM Lesson WHERE ModuleID = (SELECT ModuleID FROM Module WHERE ModuleOrder = 3))) AS Module3QuizQuestionCount,
    (SELECT COUNT(*) FROM Lesson) AS TotalLessonCount;
GO